// PicoWiFiModem Retro Edition Compact Case
// 60(W) x 40(D) x 10(H)

$fn = 48;

// ---------- Main dimensions ----------
case_w = 60;
case_d = 40;
case_h = 15; //

wall = 1.4;
corner_r = 2.5;

base_h = 12;
lid_h  = 3;

fit_clearance = 0.25;

front_panel_extra = 1.6;
front_panel_thickness = wall + front_panel_extra;

// ---------- Pico ----------
pico_l = 51;
pico_w = 21;
pico_t = 1.2;

// Pico horizontal, as far left as practical
pico_x = 3.0;
pico_y = 9.5;
pico_z = 4.0;

// ---------- Mounting ----------
post_r = 2.1;
post_h = pico_z;
screw_r = 1.0;

case_screw_r = 1.35;   // 2.7mm pilot
case_post_r  = 3.0;

// Approx Pico mounting holes
pico_hole_dx = 47;
pico_hole_dy = 11.4;
pico_hole_margin_x = 2;
pico_hole_margin_y = 4.8;

// ---------- LEDs ----------
led_count = 5;
led_r = 1.6;
led_spacing = 7.5;
led_center_x = 15;
led_center_z = 6.6;

// ---------- USB opening on left side ----------
usb_w = 10.5;   // Y direction
usb_h = 5.6;    // Z direction
usb_y = pico_y + pico_w/2 - usb_w/2;
usb_z = pico_z + 1.6;

// ---------- 6-pin connector ----------
conn6_w = 16;
conn6_h = 3;
conn6_x = 9;
conn6_z = 5.6;

// ---------- Helpers ----------
module rounded_box(w, d, h, r) {
    hull() {
        for (x = [r, w-r])
        for (y = [r, d-r])
            translate([x,y,0])
                cylinder(h=h, r=r);
    }
}

base_bottom_round = 0.8;
base_straight_h = 1.0;
module rounded_bottom_base(w, d, h, r_side, r_bottom) {

    hull() {

        // bottom rounded section
        translate([r_bottom, r_bottom, 0])
            rounded_box(
                w - 2*r_bottom,
                d - 2*r_bottom,
                0.1,
                max(r_side - r_bottom, 0.6)
            );

        // upper straight section
        translate([0,0,base_bottom_round])
            rounded_box(
                w,
                d,
                h - base_bottom_round,
                r_side
            );
    }
}

// ---------- Front acrylic LED panel ----------
acrylic_w = 54;
acrylic_h = 9.7;
acrylic_depth = 0.5;   // 2mm acrylic + clearance
acrylic_x = 3;
acrylic_z = 2.4;
acrylic_recess_depth = 2.05;

module front_acrylic_recess() {
    translate([acrylic_x, -0.1, acrylic_z])
        cube([acrylic_w, acrylic_recess_depth, acrylic_h]);
}

module base_shell() {
    difference() {

        // 外形は今まで通り。前には出さない
        rounded_bottom_base(
            case_w,
            case_d,
            base_h,
            corner_r,
            base_bottom_round
        );

        // main inner hollow
        // 前面だけ front_panel_thickness を残す
        translate([wall, front_panel_thickness, wall])
            rounded_box(
                case_w - wall*2,
                case_d - front_panel_thickness - wall,
                base_h,
                max(corner_r - wall, 0.8)
            );
    }
}

// ---------- Rounded top lid ----------
lid_straight_h = 1.5;   // BASEと面接触する垂直部
top_round_inset = 1.0;  // 上面の絞り量

module rounded_top_lid(w, d, h, r_side, r_top) {
    hull() {
        // bottom straight section: baseと同じ外形
        rounded_box(w, d, lid_straight_h, r_side);

        // top: z = h に来るようにする
        translate([r_top, r_top, h - 0.1])
            rounded_box(
                w - 2*r_top,
                d - 2*r_top,
                0.1,
                max(r_side - r_top, 0.6)
            );
    }
}

lip_h = 2.0;
lip_t = 1.2;
lip_clearance = 0.35;
lip_corner_avoid = 12;
lip_anchor = 1.5;   // LID本体側に食い込ませる量

module lid_inner_lip() {
    z = -lip_h;

    // front lip
    // 前面厚みを避けて、少し奥に配置
    translate([
        lip_corner_avoid,
        front_panel_thickness + lip_clearance,
        z
    ])
    cube([
        case_w - 2*lip_corner_avoid,
        lip_t,
        lip_h + lip_anchor
    ]);

    // rear lip
    translate([
        lip_corner_avoid,
        case_d - wall - lip_clearance - lip_t,
        z
    ])
    cube([
        case_w - 2*lip_corner_avoid,
        lip_t,
        lip_h + lip_anchor
    ]);

    // left lip
    translate([
        wall + lip_clearance,
        lip_corner_avoid,
        z
    ])
    cube([
        lip_t,
        case_d - 2*lip_corner_avoid,
        lip_h + lip_anchor
    ]);

    // right lip
    translate([
        case_w - wall - lip_clearance - lip_t,
        lip_corner_avoid,
        z
    ])
    cube([
        lip_t,
        case_d - 2*lip_corner_avoid,
        lip_h + lip_anchor
    ]);
}
module lid_shell() {
    difference() {
        // outer shell with rounded top
        rounded_top_lid(case_w, case_d, lid_h, corner_r, 1.0);

        // underside hollow; leaves thin top
        translate([wall + fit_clearance, wall + fit_clearance, -0.1])
            rounded_box(
                case_w - 2*(wall + fit_clearance),
                case_d - 2*(wall + fit_clearance),
                lid_h - wall + 0.1,
                max(corner_r - wall, 0.8)
            );
    }
}

module screw_post(x, y, h) {
    translate([x,y,0])
    difference() {
        cylinder(h=h, r=post_r);
        translate([0,0,-0.1])
            cylinder(h=h+0.2, r=screw_r);
    }
}

module case_screw_post(x, y, h) {
    translate([x,y,0])
    difference() {

        cylinder(h=h, r=case_post_r);

        translate([0,0,-0.1])
            cylinder(h=h+0.2, r=case_screw_r);
    }
}

module pico_posts() {
    screw_post(pico_x + pico_hole_margin_x,
               pico_y + pico_hole_margin_y,
               post_h);

    screw_post(pico_x + pico_hole_margin_x + pico_hole_dx,
               pico_y + pico_hole_margin_y,
               post_h);

    screw_post(pico_x + pico_hole_margin_x,
               pico_y + pico_hole_margin_y + pico_hole_dy,
               post_h);

    screw_post(pico_x + pico_hole_margin_x + pico_hole_dx,
               pico_y + pico_hole_margin_y + pico_hole_dy,
               post_h);
}

module front_led_cutouts() {
    for (i = [0:led_count-1]) {
        translate([
            led_center_x + i*led_spacing,
            -0.2,
            led_center_z
        ])
        rotate([-90,0,0])
            cylinder(h=wall+0.6+3, r=led_r);
    }
}

// ---------- Logo cut ----------
// ---------- Recessed logo ----------
logo_cut_depth = 0.8;

module top_logo_cut() {
    translate([10, 8, lid_h - logo_cut_depth])
    linear_extrude(height = logo_cut_depth + 0.3)
        text(
            "PicoWiFiModem",
            size = 3.6,
            font = "Liberation Sans:style=Bold"
        );

    translate([17, 4, lid_h - logo_cut_depth])
    linear_extrude(height = logo_cut_depth + 0.3)
        text(
            "Retro Edition",
            size = 2.8,
            font = "Liberation Sans:style=Bold"
        );
}
module base() {
    difference() {
        union() {
            base_shell();

            pico_posts();

            // lid screw posts
            case_screw_post(5, 5, base_h-0.6);
            case_screw_post(case_w-5, 5, base_h-0.6);
            case_screw_post(5, case_d-5, base_h-0.6);
            case_screw_post(case_w-5, case_d-5, base_h-0.6);
        }

        // front acrylic panel recess
        front_acrylic_recess();
        
        
        // front LED holes, BASE only
        front_led_cutouts();

        // left USB opening, enlarged for easy access
        translate([
            -0.2,
            usb_y,
            usb_z - usb_h/2
        ])
        cube([wall+0.7, usb_w, usb_h]);

        // rear 6-pin connector opening
        translate([
            conn6_x,
            case_d - wall - 0.2,
            conn6_z - conn6_h/2
        ])
        cube([conn6_w, wall+0.7, conn6_h]);

    }
}

module vent_slit(len, width, height) {
    hull() {
        translate([width/2,width/2,0])
            cylinder(h=height, r=width/2);

        translate([len-width/2,width/2,0])
            cylinder(h=height, r=width/2);
    }
}


module lid() {
    translate([0,0,base_h])
    difference() {
        union() {
            lid_shell();
            lid_inner_lip();
        }

        // recessed logo cut
        top_logo_cut();

        // screw clearance holes
        for (p=[
            [5,5],
            [case_w-5,5],
            [5,case_d-5],
            [case_w-5,case_d-5]
        ]) {
            translate([p[0], p[1], -lip_h-0.1])
                cylinder(h=lid_h+lip_h+0.4, r=1.7); // 3.4mm hole

            translate([p[0], p[1], lid_h-0.8])
                cylinder(h=1.0, r=2.0);
        }
        // ---------- top ventilation slits (Y direction) ----------
        slit_w = 1.2;
        slit_l = 18;
        slit_spacing = 4.0;

        for (i=[0:10]) {

            translate([
                10 + i*slit_spacing,
                16,
                lid_h - wall - 0.1])
                rotate([0,0,90])
                    vent_slit(slit_l, slit_w, wall + 0.4);
        }       
    }
}

module pico_preview() {
    color("green", 0.35)
    translate([pico_x, pico_y, pico_z])
        cube([pico_l, pico_w, pico_t]);

    color("silver", 0.45)
    translate([pico_x-3, pico_y + pico_w/2 - 4, pico_z + 0.6])
        cube([4, 8, 3]);
}

// ---------- Render ----------
//base();
translate([0,0,13]) lid();

// Uncomment for checking
//pico_preview();