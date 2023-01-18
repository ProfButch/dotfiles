#!/usr/bin/ruby

def _docker_container_list()
    text = `docker container list`
    lines = text.split("\n")
    return lines
end


def _get_container_at_index(which)
    to_return = nil
    lines = _docker_container_list()
    hashes = []

    for i in 1..(lines.length() -1)
        fields = lines[i].split(" ")
        data = {
            :id => fields[0],
            :image => fields[1],
            :name => fields[fields.length() -1]
        }
        hashes.append(data)
    end

    if(which -1 < hashes.length())
        to_return = hashes[which -1]
    end

    return to_return
end


def _use_container(which)
    ENV['CONTAINER'] = which
end

# -----------------------------
# Coammands
# -----------------------------


def docker_ls()
    lines = _docker_container_list()
    puts "    " + lines[0]
    for i in 1..(lines.length() -1)
        puts "#{i}.  #{lines[i]}"
    end
end


def docker_sh(which)
    cont = _get_container_at_index(which)
    if(cont != nil)
        _use_container(cont[:id])
        puts "login #{cont[:id]} #{cont[:name]}"
        cmd = "docker exec -it $CONTAINER /bin/bash"
        exec(cmd)
    else
        puts "ERROR:  Invalid index #{which}\n"
        docker_ls()
    end
end


def docker_use(which)
    cont = _get_container_at_index(which)
    if(cont != nil)
        _use_container(cont[:name])
        puts "using #{cont[:id]} #{cont[:name]}"
    else
        puts "ERROR:  Invalid index #{which}\n"
        docker_ls()
    end
end


def main
    cmd = ARGV[0]

    if(cmd == 'ls')
        docker_ls()
    elsif(cmd == 'sh')
        idx = Integer(ARGV[1])
        docker_sh(idx)
    elsif(cmd == 'use')
        idx = Integer(ARGV[1])
        docker_use(idx)
    else
        puts "ERROR:  Unknown options #{ARGV}"
    end
end


main()