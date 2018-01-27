/*
* Copyright (c) 2011-2018 Alecaddd (http://alecaddd.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
*/

public class Sequeler.Window : Gtk.ApplicationWindow {
    public weak Sequeler.Application app { get; construct; }

    public Sequeler.Layouts.HeaderBar headerbar;
    public Sequeler.Services.ActionManager action_manager;
    public Sequeler.Widgets.SettingsDialog? settings_dialog = null;

    public Gtk.AccelGroup accel_group { get; construct; }

    public Window (Sequeler.Application sequeler_app) {
        Object (
            application: sequeler_app,
            app: sequeler_app,
            icon_name: "com.github.alecaddd.sequeler"
        );
    }

    construct {
        accel_group = new Gtk.AccelGroup ();
        add_accel_group (accel_group);

        headerbar = new Sequeler.Layouts.HeaderBar (this);
        action_manager = new Sequeler.Services.ActionManager (app, this);

        build_ui ();

        move (settings.pos_x, settings.pos_y);
        resize (settings.window_width, settings.window_height);

        show_app ();
    }

    private void build_ui () {
        Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = settings.dark_theme;

        var css_provider = new Gtk.CssProvider ();
        css_provider.load_from_resource ("/com/github/alecaddd/sequeler/stylesheet.css");
        
        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        set_titlebar (headerbar);

        set_border_width (0);

        delete_event.connect ((e) => {
            return before_destroy ();
        });
    }

    public bool before_destroy () {
        app.get_active_window ().destroy ();
        on_destroy ();
        return true;
    }

    public void on_destroy () {
        uint length = app.windows.length ();

        if (length == 0) {
            Gtk.main_quit ();
        }
    }

    protected override bool delete_event (Gdk.EventAny event) {
        int width, height, x, y;

        get_size (out width, out height);
        get_position (out x, out y);

        settings.pos_x = x;
        settings.pos_y = y;
        settings.window_width = width;
        settings.window_height = height;

        return false;
    }

    public void show_app () {
        show_all ();
        show ();
        present ();
    }
}