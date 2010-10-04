
#########################################
# Extern C definitions
#########################################

cdef extern from "aosd.h":
    ctypedef int Bool

    struct cairo_t:
        pass

    struct XClassHint:
        pass

    ctypedef struct c_Aosd "Aosd":
        pass

    struct AosdMouseEvent:
        # relative coordinates
        int x
        int y
        # global coordinates
        int x_root
        int y_root
        int send_event

        # button being pressed
        unsigned int button
        unsigned long time

    # relative coordinates for positioning
    ctypedef enum c_AosdCoordinate "AosdCoordinate":
        c_COORDINATE_MINIMUM "COORDINATE_MINIMUM",
        c_COORDINATE_CENTER "COORDINATE_CENTER",
        c_COORDINATE_MAXIMUM "COORDINATE_MAXIMUM"

    ctypedef enum c_AosdTransparency "AosdTransparency":
        c_TRANSPARENCY_NONE "TRANSPARENCY_NONE",
        c_TRANSPARENCY_FAKE "TRANSPARENCY_FAKE",
        c_TRANSPARENCY_COMPOSITE "TRANSPARENCY_COMPOSITE"

    # various callbacks
    ctypedef void (*AosdRenderer)(cairo_t* cr, void* user_data)
    ctypedef void (*AosdMouseEventCb)(AosdMouseEvent* event, void* user_data)

    # object (de)allocators
    c_Aosd* aosd_new()
    void aosd_destroy(c_Aosd* aosd)

    # object inspectors
    void aosd_get_name(c_Aosd* aosd, XClassHint* result)
    void aosd_get_names(c_Aosd* aosd, char** res_name, char** res_class)
    c_AosdTransparency aosd_get_transparency(c_Aosd* aosd)
    void aosd_get_geometry(c_Aosd* aosd, int* x, int* y, int* width, int* height)
    void aosd_get_screen_size(c_Aosd* aosd, int* width, int* height)
    Bool aosd_get_is_shown(c_Aosd* aosd)

    # object configurators
    void aosd_set_name(c_Aosd* aosd, XClassHint* name)
    void aosd_set_names(c_Aosd* aosd, char* res_name, char* res_class)
    void aosd_set_transparency(c_Aosd* aosd, c_AosdTransparency mode)
    void aosd_set_geometry(c_Aosd* aosd, int x, int y, int width, int height)
    void aosd_set_position(c_Aosd* aosd, unsigned pos, int width, int height)
    void aosd_set_position_offset(c_Aosd* aosd, int x_offset, int y_offset)
    void aosd_set_position_with_offset(c_Aosd* aosd,
        c_AosdCoordinate abscissa, c_AosdCoordinate ordinate, int width, int height,
        int x_offset, int y_offset)
    void aosd_set_renderer(c_Aosd* aosd, AosdRenderer renderer, void* user_data)
    void aosd_set_mouse_event_cb(c_Aosd* aosd, AosdMouseEventCb cb, void* user_data)
    void aosd_set_hide_upon_mouse_event(c_Aosd* aosd, Bool enable)

    # object manipulators
    void aosd_render(c_Aosd* aosd)
    void aosd_show(c_Aosd* aosd)
    void aosd_hide(c_Aosd* aosd)

    # X main loop processing
    void aosd_loop_once(c_Aosd* aosd)
    void aosd_loop_for(c_Aosd* aosd, unsigned loop_ms)

    # automatic object manipulator
    void aosd_flash(c_Aosd* aosd, unsigned fade_in_ms,
        unsigned full_ms, unsigned fade_out_ms)


cdef extern from "aosd-text.h":
    ctypedef unsigned char guint8
    ctypedef signed char gint8

    void g_type_init()

    struct PangoLayout:
        pass

    struct PangoAttribute:
        pass

    PangoLayout* pango_layout_new_aosd()
    void pango_layout_unref_aosd(PangoLayout* lay)

    void pango_layout_get_size_aosd(PangoLayout* lay,
        unsigned* width, unsigned* height, int* lbearing)

    # Converts all \n occurrences into U+2028 symbol
    void pango_layout_set_text_aosd(PangoLayout* lay, char* text)
    void pango_layout_set_attr_aosd(PangoLayout* lay, PangoAttribute* attr)
    void pango_layout_set_font_aosd(PangoLayout* lay, char* font_desc)


    struct _geom:
        guint8 x_offset
        guint8 y_offset

    struct _back:
        char* color
        guint8 opacity

    struct _shadow:
        char* color
        guint8 opacity
        gint8 x_offset
        gint8 y_offset

    struct _fore:
        char* color
        guint8 opacity

    ctypedef struct TextRenderData:
        PangoLayout* lay
        int lbearing
        _geom geom
        _back back
        _shadow shadow
        _fore fore

    void aosd_text_renderer(cairo_t* cr, void* TextRenderData_ptr)
    void aosd_text_get_size(TextRenderData* trd, unsigned* width, unsigned* height)
    int aosd_text_get_screen_wrap_width(c_Aosd* aosd, TextRenderData* trd)

    void pango_layout_set_text(PangoLayout *layout, char *text, int length)


#########################################
# Python definitions
#########################################

COORDINATE_MINIMUM = c_COORDINATE_MINIMUM
COORDINATE_CENTER = c_COORDINATE_CENTER
COORDINATE_MAXIMUM = c_COORDINATE_MAXIMUM

TRANSPARENCY_NONE = c_TRANSPARENCY_NONE
TRANSPARENCY_FAKE = c_TRANSPARENCY_FAKE
TRANSPARENCY_COMPOSITE = c_TRANSPARENCY_COMPOSITE


cdef class Aosd:
    cdef c_Aosd * _aosd

    def __cinit__(self):
        self._aosd = aosd_new()

    def __dealloc__(self):
        aosd_destroy(self._aosd)

    def get_transparency(self):
        return aosd_get_transparency(self._aosd)

    def set_transparency(self, int mode):
        aosd_set_transparency(self._aosd, <c_AosdTransparency>mode)

    def get_screen_size(self):
        cdef int width, height
        aosd_get_screen_size(self._aosd, &width, &height)
        return (width, height)

    def get_geometry(self):
        cdef int x, y, width, height
        aosd_get_geometry(self._aosd, &x, &y, &width, &height)
        return (x, y, width, height)

    def set_geometry(self, int x, int y, int width, int height):
        aosd_set_geometry(self._aosd, x, y, width, height)

    def set_position(self, unsigned pos, int width, int height):
        aosd_set_position(self._aosd, pos, width, height)

    def set_position_offset(self, int x_offset, int y_offset):
        aosd_set_position_offset(self._aosd, x_offset, y_offset)

    def set_position_with_offset(self, int abscissa, int ordinate, int width, int height,
        int x_offset, int y_offset):
        aosd_set_position_with_offset(self._aosd, <c_AosdCoordinate> abscissa, <c_AosdCoordinate> ordinate,
            width, height, x_offset, y_offset)

    def set_hide_upon_mouse_event(self, Bool enable):
        aosd_set_hide_upon_mouse_event(self._aosd, enable)

    def is_shown(self):
        return aosd_get_is_shown(self._aosd)

    def show(self):
        aosd_show(self._aosd)

    def hide(self):
        aosd_hide(self._aosd)

    def render(self):
        aosd_render(self._aosd)

    def loop_once(self):
        aosd_loop_once(self._aosd)

    def loop_for(self, unsigned loop_ms):
        aosd_loop_for(self._aosd, loop_ms)

    def flash(self, unsigned fade_in_ms, unsigned full_ms, unsigned fade_out_ms):
        aosd_flash(self._aosd, fade_in_ms, full_ms, fade_out_ms)

def __convert_text(text):
    if isinstance(text, unicode): # most common case first
        utf8_data = text.encode('UTF-8')
    elif isinstance(text, str):
        text.decode('ASCII') # trial decoding, or however you want to check for plain ASCII data
        utf8_data = text
    else:
        raise ValueError("requires text input, got %s" % type(text))
    return utf8_data

cdef class AosdText(Aosd):
    cdef TextRenderData _rend
    cdef object _text
    cdef object _font_desc
    cdef object _back_color
    cdef object _fore_color
    cdef object _shadow_color

    def __cinit__(self):
        g_type_init()
        self._rend.lay = pango_layout_new_aosd()
        aosd_set_renderer(self._aosd, aosd_text_renderer, &self._rend)

    def __dealloc__(self):
        pango_layout_unref_aosd(self._rend.lay)

    def set_text(self, text):
        self._text = __convert_text(text)
        pango_layout_set_text(self._rend.lay, self._text, -1)

    def get_text_size(self):
        cdef unsigned int width, height
        aosd_text_get_size(&self._rend, &width, &height)
        return (width, height)

    def set_font(self, font_desc):
        self._font_desc = __convert_text(font_desc)
        pango_layout_set_font_aosd(self._rend.lay, self._font_desc)

    property back_color:
        def __get__(self):
            if self._rend.back.color == NULL:
                return None
            return self._rend.back.color

        def __set__(self, value):
            if value is None:
                self._back_color = None
                self._rend.back.color = NULL
            else:
                self._back_color = __convert_text(value)
                self._rend.back.color = self._back_color

    property back_opacity:
        def __get__(self):
            return self._rend.back.opacity

        def __set__(self, value):
            self._rend.back.opacity = value

    property fore_color:
        def __get__(self):
            if self._rend.fore.color == NULL:
                return None
            return self._rend.fore.color

        def __set__(self, value):
            if value is None:
                self._fore_color = None
                self._rend.fore.color = NULL
            else:
                self._fore_color = __convert_text(value)
                self._rend.fore.color = self._fore_color

    property fore_opacity:
        def __get__(self):
            return self._rend.fore.opacity

        def __set__(self, value):
            self._rend.fore.opacity = value

    property shadow_color:
        def __get__(self):
            if self._rend.shadow.color == NULL:
                return None
            return self._rend.shadow.color

        def __set__(self, value):
            if value is None:
                self._shadow_color = None
                self._rend.shadow.color = NULL
            else:
                self._shadow_color = __convert_text(value)
                self._rend.shadow.color = self._shadow_color

    property shadow_opacity:
        def __get__(self):
            return self._rend.shadow.opacity

        def __set__(self, value):
            self._rend.shadow.opacity = value

    property shadow_x_offset:
        def __get__(self):
            return self._rend.shadow.x_offset

        def __set__(self, value):
            self._rend.shadow.x_offset = value

    property shadow_y_offset:
        def __get__(self):
            return self._rend.shadow.y_offset

        def __set__(self, value):
            self._rend.shadow.y_offset = value

    property geom_x_offset:
        def __get__(self):
            return self._rend.geom.x_offset

        def __set__(self, value):
            self._rend.geom.x_offset = value

    property geom_y_offset:
        def __get__(self):
            return self._rend.geom.y_offset

        def __set__(self, value):
            self._rend.geom.y_offset = value

