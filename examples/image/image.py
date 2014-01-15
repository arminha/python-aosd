# coding=utf8

#
# python-aosd -- python bindings for libaosd
#
# Copyright (C) 2010 Armin Haeberling
#
# Based on the image example from libaosd.
#

import sys
import argparse
import cairo

import aosd

MARGIN = 10
RADIUS = 20
WIDTH = 185
HEIGHT = 220

def round_rect(context, x, y, w, h, r):
    context.new_path()
    context.move_to(x+r, y)
    context.line_to(x+w-r, y) # top edge
    context.curve_to(x+w, y, x+w, y, x+w, y+r)
    context.line_to(x+w, y+h-r) # right edge
    context.curve_to(x+w, y+h, x+w, y+h, x+w-r, y+h)
    context.line_to(x+r, y+h) # bottom edge
    context.curve_to(x, y+h, x, y+h, x, y+h-r)
    context.line_to(x, y+r) # left edge
    context.curve_to(x, y, x, y, x+r, y)
    context.close_path()


def render(context, data):
    image = data['image']
    options = data['options']
    width = image.get_width()
    height = image.get_height()

    context.set_source_rgba(0, 0, 0, 1)
    round_rect(context, 0, 0, width + (2 * MARGIN),
        height + (2 * MARGIN), RADIUS)
    context.fill()

    context.save()
    context.set_source_surface(image, MARGIN, MARGIN)
    context.paint_with_alpha(options.alpha / 100.0)
    context.restore()


def parse_options(argv):
    parser = argparse.ArgumentParser(description='')

    # display
    group = parser.add_argument_group('Display Options')
    group.add_argument('--opaque', '-o', dest='transparent',
        action='store_false', default=True,
        help='turn off transparent background')
    group.add_argument('--alpha', '-a', dest='alpha', type=int,
        help='alpha level of a displayed image (0:100)', default=50)

    # position
    group = parser.add_argument_group('Position Options')
    group.add_argument('--position', '-p', dest='pos',
        type=int, help='window position (0:8)', default=4)
    group.add_argument('-x', dest='x', type=int,
        help='x offset coordinate for window', default=0)
    group.add_argument('-y', dest='y', type=int,
        help='y offset coordinate for window', default=0)

    # image
    group = parser.add_argument_group('Image Options')
    group.add_argument('filename', type=file, help='image to display',
        metavar='PATH')

    options = parser.parse_args(argv)
    if (options.pos < 0 or options.pos > 8):
        options.pos = 4
    if (options.alpha < 0):
        options.alpha = 0
    if (options.alpha > 100):
        options.alpha = 100;
    return options


def main(argv):
    options = parse_options(argv[1:])
    image = cairo.ImageSurface.create_from_png(options.filename)
    width  = image.get_width()
    height = image.get_height()
    osd = aosd.Aosd()
    osd.set_transparency(
        aosd.TRANSPARENCY_COMPOSITE if options.transparent
        else aosd.TRANSPARENCY_NONE)
    osd.set_position(options.pos, width + 2 * MARGIN, height + 2 * MARGIN)
    osd.set_position_offset(options.x, options.y)
    osd.set_renderer(render, {'image': image, 'options':options})
    osd.flash(300, 3000, 300)


if __name__ == "__main__":
    main(sys.argv)

