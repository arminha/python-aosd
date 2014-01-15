# coding=utf8

#
# python-aosd -- python bindings for libaosd
#
# Copyright (C) 2010 Armin Haeberling
#
# Based on the animation example from libaosd.
#

import cairo
import aosd

RADIUS = 40

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
    context.set_source_rgba(data['alpha'], 0, 0, 0.7)
    round_rect(context, 0, 0, 180, 230, RADIUS)
    context.fill()

    context.set_source_rgba(1, 1, 1, 1.0)
    round_rect(context, 10, 10, 160, 210, RADIUS)
    context.stroke()

    context.save()
    context.set_source_rgba(1, 1, 1, 1.0)
    context.set_source_surface(data['foot'], 20, 20)
    context.paint()
    context.restore()

def main():
    image = "/usr/share/pixmaps/gnome-background-image.png"
    foot = cairo.ImageSurface.create_from_png(image)
    alpha = 0.5
    data = { 'foot':foot, 'alpha':alpha }

    osd = aosd.Aosd()
    osd.set_transparency(aosd.TRANSPARENCY_COMPOSITE)
    osd.set_hide_upon_mouse_event(True)
    osd.set_geometry(50, 50, 180, 230)
    osd.set_renderer(render, data)

    osd.show()

    osd.loop_once()

    dalpha = 0.05

    while True:
        alpha += dalpha
        if (alpha >= 1.0):
            alpha = 1.0
            dalpha = -dalpha
        elif (alpha <= 0.0):
            alpha = 0.0
            dalpha = -dalpha

        data['alpha'] = alpha
        osd.render()
        osd.loop_for(100)
        if not osd.is_shown():
            break

if __name__ == "__main__":
    main()

