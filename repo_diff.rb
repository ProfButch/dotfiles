#!/usr/bin/env ruby
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class DiffProps
    attr_accessor :file_name
    attr_accessor :word_count
    attr_accessor :common_pct
    attr_accessor :deleted_pct
    attr_accessor :changed_pct
    attr_accessor :inserted_pct

    def initialize()
        @file_name = ""
        @word_count = 0
        @common_pct = 0.0
        @inserted_pct = 0.0
        @changed_pct = 0.0
        @deleted_pct = 0.0            
    end

    def to_s()
        return "#{@file_name}\n words = #{@word_count} \n common = #{@common_pct}\n del=#{@deleted_pct}\n ins=#{@inserted_pct}\n chg=#{@changed_pct}"
    end
end


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class Difference
    attr_accessor :f1
    attr_accessor :f2

    def initialize()
        @f1 = DiffProps.new
        @f2 = DiffProps.new
    end

    def to_s()
        return "#{@f1}\n#{@f2}"
    end

    def get_base_file_name()
        to_return = File.basename(@f1.file_name)
        if(to_return != File.basename(@f2.file_name))
            to_return += " | " + File.basename(@f2.file_name)
        end
        return to_return
    end

    def simple_s()
        return "#{get_base_file_name()}:   #{float_to_pct(@f1.common_pct)}"
    end

    def float_to_pct(f)
        return "#{f * 100}%"
    end
end


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class DirFiles
    attr_accessor :base_path
    attr_accessor :files

    def initialize(base_path)
        @base_path = base_path
        @files = []
    end

    def add_files_with_extension(ext)
        found = `find #{@base_path} -iname '*#{ext}'`.split("\n")
        found.each{ |f| 
            f.sub!(@base_path, '')
        }
        @files.concat(found)
    end

    def get_full_path_if_exists(subpath)
        idx = @files.index(subpath)
        to_return = nil
        if(idx != nil)
            to_return = @base_path + @files[idx]
        end
        return to_return
    end
end

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class DirDiff
    attr_reader :files1
    attr_reader :files2
    attr_reader :diffs
    attr_reader :summary

    def initialize(path1, path2)
        @files1 = DirFiles.new(path1)
        @files2 = DirFiles.new(path2)
        @diffs = {}
        @summary = ""
    end

    def add_files_with_extension(ext)
        @files1.add_files_with_extension(ext)
        @files2.add_files_with_extension(ext)
    end

    def populate_diffs()
        num_over = 0
        total_pct = 0.0
        full_match = 0

        @files1.files.each{ |f| 
            other = @files2.get_full_path_if_exists(f)
            if(other != nil)
                d = compare_files(@files1.get_full_path_if_exists(f), other)
                @diffs[f] = d
                if(d.f1.common_pct > 0.85)
                    num_over += 1
                    total_pct += d.f1.common_pct
                    if(d.f1.common_pct == 1.0)
                        full_match += 1
                    end
                end
            end
        }

        avg_of_over = total_pct / num_over
        @summary = "#{num_over}/#{@files1.files.length()} Questionable:  Avg over = #{avg_of_over}.  #{full_match} @ 100%"
    end

    def print_questionable()
        @diffs.each { |path, diff| 
            if(diff.f1.common_pct > 0.85)
                puts(diff.simple_s())
            end
        }
    end
end




# -----------------------------------------------------------------------------
# Start Script
# -----------------------------------------------------------------------------
def pct_to_float(pct)
    f = pct.sub!("%", "").to_f
    f = f / 100.0
    return f
end


def parse_diff_line(line)
    s1 = line.split(":")
    props = DiffProps.new()
    props.file_name = s1[0]

    s2 = s1[1].split(" ")
    # puts s2
    props.word_count = s2[0]
    props.common_pct = pct_to_float(s2[3])
    if(s2[7] == 'deleted')
        props.deleted_pct = pct_to_float(s2[6])
    else
        props.inserted_pct = pct_to_float(s2[6])
    end
    props.changed_pct = pct_to_float(s2[9])

    return props
end


def compare_files(f1, f2)
    output = `wdiff -s123 #{f1} #{f2}`
    # puts output

    lines = output.split("\n")
    p1 = parse_diff_line(lines[0])
    p2 = parse_diff_line(lines[1])

    diff = Difference.new()
    diff.f1 = p1
    diff.f2 = p2
    return diff
end


# ------------------------------------------------------------------
# Main and test methods
# ------------------------------------------------------------------
def compare_two_files()
    f1 = '/temp_github/jerry0820/Assets/Scripts/BulletSpawner.cs' 
    f2 = '~/temp_github/robin3a5/Assets/Scripts/BulletSpawner.cs'
    d = compare_files(f1, f2)
    
    puts(d.simple_s)
end


def compare_two_directories(d1, d2)
    puts "----------------------------------------"
    puts " Comparing [#{d1}] with [#{d2}]"
    dirs = DirDiff.new(d1, d2)
    dirs.add_files_with_extension('cs')
    dirs.populate_diffs()
    print('    ')
    puts dirs.summary
    puts "----------------------------------------"
    dirs.print_questionable()
end


def compare_x_directories(dirs)
    for i in 0..dirs.length() -1
        for j in (i + 1)..dirs.length() -1            
            compare_two_directories(dirs[i], dirs[j])
        end
    end
end

def make_dirs(base_path, subdirs)
    to_return = []
    subdirs.each {|s|
        to_return.append(base_path + s)
    }
    return to_return
end


def compare_temp_github()
    found = `find ~/temp_github -iname 'Assets'`.split("\n")
    compare_x_directories(found)
end

def main
    # compare_two_directories('/Users/butchuc/temp_github/jerry0820/Assets/', '/Users/butchuc/temp_github/robin3a5/Assets/')
    # dirs = make_dirs('/Users/butchuc/temp_github/', 
    #     ['Baconchicken42', 'ChicknWings', 'JaredMcCu', 'JonathandNidhog'])
    # compare_x_directories(dirs)
    compare_temp_github()
end

main()