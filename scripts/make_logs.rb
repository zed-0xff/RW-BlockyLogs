#!/usr/bin/env ruby
require 'fileutils'
require 'zpng'
include ZPNG

def mask src, mask_id = 'a'
  mask = Image.new(File.open(File.join(File.dirname(__FILE__), "mask_" + mask_id + ".png"),"rb"))
  src.copy_from(mask)
end

def make_logs src_fname
  name = File.basename(src_fname).split(".").first.sub(/HorizontalDiagonal/,'').split('Block').first
  3.times do |idx|
    letter = ('a'.ord+idx).chr
    src = Image.new(open(src_fname, "rb"))
    dst = Image.new width: 64, height: 64

    case idx
    when 0
      dst.copy_from(src, dst_y: 2)
    when 1
      dst.copy_from(src, dst_y: 2, dst_x: -9)
      dst.copy_from(src, dst_y: 2, dst_x: +9)
    when 2
      dst.copy_from(src, dst_y: 4, dst_x: -9)
      dst.copy_from(src, dst_y: 4, dst_x: +9)
      dst.copy_from(src, dst_y: -13)
    end

    dirname = File.join("Textures/Blocky/Logs", name)
    fname = File.join(dirname, name + "_#{letter}.png")
    FileUtils.mkdir_p(dirname)
    puts "[.] #{fname}"
    mask(dst, letter).save(fname)
  end
end

BAMBOO_TEX_FNAME = File.join(File.dirname(__FILE__), "bamboo_row.png")
BAMBOO_TEX = Image.new(open(BAMBOO_TEX_FNAME, "rb"))

def make_bamboo_row dst, y, n, xadd: 0
  x = (64 - n*4)/2 + xadd
  n.times do |i|
    dst.copy_from(BAMBOO_TEX, dst_x: x + i*4, dst_y: y)
  end
end

def make_bamboo
  name = 'Bamboo'

  3.times do |idx|
    dst = Image.new width: 64, height: 64
    letter = ('a'.ord+idx).chr

    xadd = 0
    y = 46-16

    rows =
      case idx
      when 0
        xadd = -4
        [6, 4, 2]
      when 1
        xadd = -4
        [8, 8, 6, 6, 4, 2]
      when 2
        xadd = -4
        [10, 10, 8, 8, 6, 6, 4, 2]
      end

    rows.each do |n|
      make_bamboo_row dst, y, n, xadd: xadd
      y -= 4
    end

    dirname = File.join("Textures/Blocky/Logs", name)
    fname = File.join(dirname, name + "_#{letter}.png")
    FileUtils.mkdir_p(dirname)
    puts "[.] #{fname}"
    dst.save(fname)
  end
end

Dir["../BlockyCore/Textures/Blocky/Alpha/?/*LogHorizontalDiagonal.png"].each do |fname|
  make_logs fname
end

make_bamboo
