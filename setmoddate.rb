#!/usr/bin/env ruby
# frozen_string_literal: true

# Set file modification time based on a timestamp parsed from the filename.
#
# Patterns supported:
# 1) /(P|V)\d{5}-\d{6}/ e.g. "P80126-141905" or "V80126-141905"
#    Interpreted as: 201Y MM DD - hh mm ss  (the leading Y is prefixed with 201)
#    Example: P80126-141905 -> 2018-01-26 14:19:05
# 2) /\d{8}_\d{6}/ e.g. "20190810_152122"
#    Interpreted as: YYYY MM DD _ hh mm ss
#
# Usage:
#   ruby set_mtime_from_name.rb [options]
#
# Options:
#   -w        Write changes (default is dry-run)
#   -h        Show help
#
# Behavior:
#   • Dry run (default): prints files with NO match first, then planned changes.
#   • With -w: applies mtime updates and prints what was changed; non-matching files are listed first.

require 'time'
require 'optparse'

WRITE = { enabled: false }

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [-w]"
  opts.on('-w', '--write', 'Write changes (otherwise dry-run)') { WRITE[:enabled] = true }
  opts.on('-h', '--help', 'Show this help') do
    puts opts
    exit 0
  end
end.parse!

targets = Dir.children('downloads').map { |f| File.expand_path('downloads/' + f) }.select { |p| File.file?(p) }

def parse_time_from_name(name)
  base = File.basename(name)

  # Pattern 1: P/V + YMMDD-HHMMSS  (e.g., P80126-141905)
  if (m = base.match(/(?:\b|_)([PV])(\d{1})(\d{2})(\d{2})-(\d{2})(\d{2})(\d{2})(?:\b|_)/))
    _pv, y, mm, dd, hh, mi, ss = m.captures
    year = 2010 + y.to_i # interpret Y as 201Y per requirement
    return Time.new(year, mm.to_i, dd.to_i, hh.to_i, mi.to_i, ss.to_i, Time.now.getlocal.utc_offset)
  end

  # Pattern 2: YYYYMMDD_HHMMSS (e.g., 20190810_152122)
  if (m = base.match(/(?:\b|_)(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})(?:\b|_)/))
    yyyy, mm, dd, hh, mi, ss = m.captures
    return Time.new(yyyy.to_i, mm.to_i, dd.to_i, hh.to_i, mi.to_i, ss.to_i, Time.now.getlocal.utc_offset)
  end

 # Pattern 3: YYYYMMDDHHMMSS (e.g., 20200523095347)
  if (m = base.match(/(?:^|[^0-9])(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(?:$|[^0-9])/))
    yyyy, mm, dd, hh, mi, ss = m.captures
    # Avoid false positives by preferring other patterns first; this remains valid here.
    return Time.new(yyyy.to_i, mm.to_i, dd.to_i, hh.to_i, mi.to_i, ss.to_i, Time.now.getlocal.utc_offset)
  end

  # Pattern 4: YYYY-MM-DD-HHMMSS (e.g., 2022-08-27-193414)
  if (m = base.match(/(?:^|[^0-9])(\d{4})-(\d{2})-(\d{2})-(\d{2})(\d{2})(\d{2})/))
    yyyy, mm, dd, hh, mi, ss = m.captures
    return Time.new(yyyy.to_i, mm.to_i, dd.to_i, hh.to_i, mi.to_i, ss.to_i, Time.now.getlocal.utc_offset)
  end
  #
  # Pattern 2: YYYYMMDD_HHMMSS (e.g., 20190810-152122)
  if (m = base.match(/(?:\b|_)(\d{4})(\d{2})(\d{2})-(\d{2})(\d{2})(\d{2})(?:\b|_)/))
    yyyy, mm, dd, hh, mi, ss = m.captures
    return Time.new(yyyy.to_i, mm.to_i, dd.to_i, hh.to_i, mi.to_i, ss.to_i, Time.now.getlocal.utc_offset)
  end

  nil
rescue ArgumentError
  # Invalid calendar values (e.g., Feb 30) will raise; treat as no match.
  nil
end

skipped = []
planned = []

targets.each do |path|
  ts = parse_time_from_name(path)
  if ts.nil?
    skipped << path
  else
    planned << [path, ts]
  end
end

# Output — non-updated files first
if WRITE[:enabled]
  puts "Mode: WRITE (applying changes)\n\n"
else
  puts "Mode: DRY RUN (no changes will be written)\n\n"
end

unless skipped.empty?
  puts "Files with no recognizable timestamp (#{skipped.size}):"
  skipped.sort.each { |p| puts "  - #{p}" }
  puts
end

if planned.empty?
  puts "No files to update."
  exit 0
end

label = WRITE[:enabled] ? "Setting mtime" : "Would set mtime"
puts "#{label} for #{planned.size} file(s):"
planned.sort_by! { |path, _| path }
planned.each do |path, ts|
  ts_str = ts.strftime('%Y-%m-%d %H:%M:%S')
  puts "  - #{path}\n      -> #{ts_str}"
end
puts

# Perform updates if requested
if WRITE[:enabled]
  planned.each do |path, ts|
    begin
      File.utime(ts, ts, path)
    rescue => e
      warn "  ! Failed to update #{path}: #{e.message}"
    end
  end
  puts "Done."
else
  puts "Dry run complete. Use -w to apply changes."
end
