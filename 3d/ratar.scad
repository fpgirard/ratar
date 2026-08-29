// ============================================================
//  PCB Enclosure (Round) — Parametric OpenSCAD Design (BOSL2)
//  Variant of pcb_enclosure.scad with a fully cylindrical 50mm-
//  diameter outer shell instead of a rectangular one. The internal
//  cavity (and its standoffs) is centered in the shell. The cable
//  hole is a stepped bore: a small through-hole reaches the cavity,
//  opening into a wider, shallow counterbore pocket cut into the
//  curved outer surface -- that pocket's flat bottom leaves a
//  controlled hole_wall_thickness shoulder for the cable/connector.
//  Above upper_cavity_start_height the cavity steps out to a wider
//  footprint (upper_cavity_length x upper_cavity_width) that runs up
//  through the top of the base -- that wider opening is also what the
//  lid's lip is now sized to. A USB-C slot sits in the same +X wall as
//  the circular hole, usb_c_offset_z above that hole's center.
//  The body is box_height tall overall. The lid is held on by two M2
//  countersunk bolts (centered in X, lid_bolt_spacing_y apart in Y)
//  threading into matching heat-set insert holes blind-drilled into
//  the body's top rim.
//  Units: mm
// ============================================================

include <BOSL2/std.scad>
include <BOSL2/screws.scad>

// --- PCB assembly bounding box (board + all components) ---
pcb_length       = 30; // Board length (X)
pcb_width        = 15; // Board width (Y) -- the two end walls face this dimension
pcb_stack_height = 15; // Overall height of the board assembly (PCB thickness plus
                        // the tallest component on either face), resting on the shoulders

// --- Fit clearances ---
side_clearance = 0.4; // Per-side X/Y clearance between the board edge and the
                       // cavity wall, so the board drops in without binding
                       // (top_clearance, the headroom above the tallest
                       // component, is derived below from box_height --
                       // it MUST stay greater than lip_engage_depth, or the
                       // lid's alignment lip will crush tall components)

// --- Shell ---
outer_dia       = 50;  // Outer diameter of the cylindrical shell
box_height      = 23;  // Overall height of the body, floor to rim
floor_thickness = 2;   // Floor thickness under the support shoulders
lid_thickness   = 2.5; // Lid panel thickness

// --- Cavity placement ---
cavity_offset_x = 0; // How far the internal cavity (and everything inside it)
                      // is shifted off-center, towards the +X cable-hole side.
                      // 0 = centered in the round shell.

// --- PCB support standoffs (2 per 30mm-long side wall, 4 total) ---
pcb_support_height = 4;   // Height above the floor's top surface where the PCB
                           // rests -- also the reference height for the side hole
standoff_length = 4;      // Standoff size along X (the wall's running direction)
standoff_depth  = 1.5;    // How far each standoff protrudes inward from its side
                           // wall (Y)
standoff_inset  = 2;      // Gap between each end wall's inner face and the near
                           // edge of the nearest standoff, along X

// --- Upper standoffs (4, for the upper cutout's board) -- same X offsets
// and X/Y footprint as the standoffs above, just taller and set against the
// upper cutout's (wider) side walls instead ---
upper_standoff_height = 6.75; // Height above upper_cavity_z where these rest --
                              // raised 1.5mm for taller PCB headers

// --- Round center standoffs (2, likely for screw-mounting the PCB) ---
round_standoff_dia      = 3.25; // Outer diameter of each round standoff
round_standoff_spacing_y = 9.5; // Center-to-center spacing between the two, along Y
round_standoff_offset_x  = 5.75; // Offset from center (X=0) towards the hole wall (+X)
round_standoff_height    = pcb_support_height + 2; // 2mm taller than the corner
                              // standoffs, so this pair's top surface sits 2mm higher

// --- Side hole (cable/connector cutout, +X side) ---
side_hole_dia              = 7.2;  // Through-hole diameter, cavity to counterbore
side_hole_bottom_clearance = 0.5;  // Gap between the hole's bottom edge and the
                                   // interior floor
hole_wall_thickness        = 3.25; // Thickness of the flat shoulder left at the
                                   // counterbore's bottom, for the cable hole
counterbore_dia            = 10;   // Diameter of the shallow flat-bottomed pocket
                                   // cut into the curved outer surface

// --- Upper cutout (second, wider cavity step above the board cavity) ---
upper_cavity_length     = 33.5; // X extent of the upper cutout
upper_cavity_width      = 22.5; // Y extent of the upper cutout
upper_cavity_start_height = 10; // Height above the interior floor where the
                                 // cutout widens -- it continues up through
                                 // the top of the base from there
upper_cavity_offset_x   = 1; // Shifted 1mm in +X from the shell's center --
                                 // the lid lip follows this too

// --- USB-C cutout (+X wall, same side as the circular hole) ---
usb_c_width    = 11;  // Slot width, along Y -- reaches the cavity for the PCB connector
usb_c_height   = 4.2; // Slot height, along Z
usb_c_corner_r = 1.5; // Corner rounding -- close to usb_c_height/2 for a stadium slot
usb_c_offset_z = 10.25; // How far above the circular hole's center the slot is centered
usb_wall_thickness = 0.5; // Thickness of the flat shoulder left between the cavity
                           // and the housing pocket's bottom, for the USB-C slot --
                           // same stepped-bore idea as hole_wall_thickness above

// USB-C cable housing pocket: a shallow flat-bottomed recess in the curved
// outer surface, concentric with the slot above, sized to clear a cable
// plug housing -- doesn't reach the cavity, just the housing's flare
usb_pocket_width    = 12;  // Pocket width, along Y (cable housing width)
usb_pocket_height   = 8;   // Pocket height, along Z (cable housing height)
usb_pocket_corner_r = 2;   // Rounded corners, not a full stadium

// --- Lid retention lip ---
lip_engage_depth   = 1.25;   // How far the lid's lip drops down inside the box mouth
lip_side_clearance = 0.3; // Per-side clearance so the lip presses in without binding

// --- Lid fasteners: M2 socket-head (Allen) bolts into heat-set inserts in
// the body, modeled with BOSL2's screws.scad (screw_hole()) so the shank
// clearance and head size come from real ISO M2 spec data instead of
// hand-picked numbers. Centered in X, spaced lid_bolt_spacing_y apart in Y.
// Sized for M2x8 -- a shallow spot-face counterbore seats the socket head
// squarely; unlike a countersunk head, a socket head normally sits proud
// rather than flush, so this stays shallow (rather than the library's
// default full-head-height counterbore) to keep the lid from getting
// paper-thin underneath it ---
lid_bolt_spacing_y = 30;  // Center-to-center spacing between the two bolts (Y)
lid_bolt_length    = 8;   // M2x8
m2_counterbore_depth = 1; // Spot-face depth -- head sits proud above this,
                             // well short of the socket head's ~2mm height

m2_insert_dia   = 3.5; // Heat-set insert outer diameter (M2 brass/copper insert)
m2_insert_depth = 9;   // Blind hole depth in the body for the insert --
                        // deep enough that an M2x8 bolt doesn't bottom out

// --- Base floor label: "RATAR" engraved (inverted, i.e. recessed rather
// than raised) into the interior floor -- hidden under the board once
// assembled. It reads the same forwards and backwards; as a nod to that,
// the last R is mirrored vertically and recessed 1mm deeper than the rest ---
label_text        = "RATAR"; // everything but the mirrored last letter
label_last_letter = "R";
label_font_size   = 3.5;
label_gap         = 1;   // gap between "RATA" and the mirrored R, along X
label_x           = -3;  // floor position, clear of both standoff types
label_depth       = 0.3; // engrave depth for the normal letters
label_mirror_offset = 1; // extra depth for the mirrored R, per the request

// --- Derived dimensions ---
internal_length = pcb_length + 2 * side_clearance;
internal_width  = pcb_width + 2 * side_clearance;
internal_height = box_height - floor_thickness;
top_clearance   = internal_height - pcb_support_height - pcb_stack_height;

outer_radius = outer_dia / 2;

assert(top_clearance > lip_engage_depth, "top_clearance (derived from box_height) must exceed lip_engage_depth, or the lid's lip will crush tall components");
assert(label_depth + label_mirror_offset < floor_thickness - 0.3, "floor label (plus the mirrored R's extra depth) would cut through the floor");
assert(lid_bolt_spacing_y / 2 - m2_insert_dia / 2 > upper_cavity_width / 2, "M2 insert holes overlap the upper cavity");
assert(lid_bolt_spacing_y / 2 + m2_insert_dia / 2 < outer_radius, "M2 insert holes breach the outer shell");

// Global X of the cavity's near (hole-side) wall, and of the counterbore's
// flat bottom (hole_wall_thickness further out)
cavity_edge_x = cavity_offset_x + internal_length / 2;
flat_bottom_x = cavity_edge_x + hole_wall_thickness;

side_hole_z = floor_thickness + side_hole_bottom_clearance + side_hole_dia / 2;

// Upper cutout: absolute Z where it starts, and its near (hole-side) wall
upper_cavity_z     = floor_thickness + upper_cavity_start_height;
upper_cavity_edge_x = upper_cavity_offset_x + upper_cavity_length / 2;

// USB-C slot: centered on the circular hole's height plus the requested offset
usb_c_z = side_hole_z + usb_c_offset_z;

// USB-C housing pocket's flat bottom (usb_wall_thickness in from the cavity
// wall), and the pocket depth that puts it there, measured from the outer surface
usb_flat_bottom_x = upper_cavity_edge_x + usb_wall_thickness;
usb_pocket_depth  = outer_radius - usb_flat_bottom_x;

assert(usb_pocket_depth > 0, "usb_wall_thickness leaves no room for the USB-C housing pocket -- reduce it or shrink the upper cutout");

$fn = 128;

// Plain cylindrical shell -- no chord cut needed now that the counterbore
// pocket handles the flat face locally
module outer_shell(height) {
    cyl(h = height, d = outer_dia, anchor = BOTTOM);
}

// Support standoffs: a short block on the inner face of each 30mm-long side
// wall, near each end, rising from the floor to pcb_support_height, that the
// PCB rests on top of
module standoffs() {
    for (end = [-1, 1], side = [-1, 1])
        translate([end * (internal_length / 2 - standoff_inset - standoff_length / 2),
                    side * (internal_width / 2 - standoff_depth / 2),
                    floor_thickness])
            cuboid([standoff_length, standoff_depth, pcb_support_height], anchor = BOTTOM);
}

// Upper standoffs: same X offsets and X/Y footprint as standoffs() above,
// but set against the upper cutout's (wider) side walls, resting from
// upper_cavity_z up to upper_standoff_height, for a board in that cutout
module upper_standoffs() {
    for (end = [-1, 1], side = [-1, 1])
        translate([end * (internal_length / 2 - standoff_inset - standoff_length / 2),
                    side * (upper_cavity_width / 2 - standoff_depth / 2),
                    upper_cavity_z])
            cuboid([standoff_length, standoff_depth, upper_standoff_height], anchor = BOTTOM);
}

// Round center standoffs: 2 posts rising from the floor to pcb_support_height,
// offset towards the hole wall (+X), for screw-mounting the PCB
module round_standoffs() {
    for (y = [-1, 1])
        translate([round_standoff_offset_x, y * round_standoff_spacing_y / 2, floor_thickness])
            cyl(h = round_standoff_height, d = round_standoff_dia, anchor = BOTTOM);
}

// "RATAR" engraved into the interior floor -- "RATA" at normal depth, then
// the mirrored last R recessed label_mirror_offset deeper, right after it
module floor_label_cut() {
//    translate([label_x, 0, floor_thickness - label_depth - label_mirror_offset])
        linear_extrude(height = label_depth + label_mirror_offset + 0.2)
            translate([7.5, 0])
                mirror([1, 0, 0])
                    text(label_text, size = label_font_size, halign = "left", valign = "center",
                         font = "Liberation Sans:style=Bold");
}

// Tray: round shell + floor, open top, support standoffs (all shifted towards
// +X), and a stepped cable hole (small through-hole + shallow counterbore)
module pcb_box_base() {
    difference() {
        outer_shell(box_height);

        // Main cavity, oversized upward so the top is fully open
        translate([cavity_offset_x, 0, 0])
            up(floor_thickness)
                cuboid([internal_length, internal_width, internal_height + 20], anchor = BOTTOM);

        // Upper cutout: widens the cavity starting upper_cavity_start_height
        // above the interior floor, continuing up through the top of the base
        translate([upper_cavity_offset_x, 0, 0])
            up(upper_cavity_z)
                cuboid([upper_cavity_length, upper_cavity_width, box_height + 20], anchor = BOTTOM);

        // USB-C cutout: stadium slot through the +X wall, same side as the
        // circular hole, centered usb_c_offset_z above that hole's center --
        // cavity out to the housing pocket's flat bottom (usb_wall_thickness)
        translate([upper_cavity_edge_x + usb_wall_thickness / 2, 0, usb_c_z])
            cuboid([usb_wall_thickness + 4, usb_c_width, usb_c_height],
                   rounding = usb_c_corner_r, edges = "X", anchor = CENTER);

        // USB-C cable housing pocket: shallow flat-bottomed recess in the
        // curved outer surface, from the surface in to usb_flat_bottom_x,
        // sized to clear a plug housing (usb_pocket_width x usb_pocket_height)
        translate([(usb_flat_bottom_x + outer_radius + 3) / 2, 0, usb_c_z])
            cuboid([outer_radius + 3 - usb_flat_bottom_x, usb_pocket_width, usb_pocket_height],
                   rounding = usb_pocket_corner_r, edges = "X", anchor = CENTER);

        // Cable/connector through-hole: cavity out to the counterbore's flat bottom
        translate([cavity_edge_x + hole_wall_thickness / 2, 0, side_hole_z])
            yrot(90)
                cyl(h = hole_wall_thickness + 4, d = side_hole_dia, anchor = CENTER);

        // Counterbore pocket: shallow flat-bottomed recess cut into the curved
        // outer surface, from the surface in to flat_bottom_x
        translate([(flat_bottom_x + outer_radius + 3) / 2, 0, side_hole_z])
            yrot(90)
                cyl(h = outer_radius + 3 - flat_bottom_x, d = counterbore_dia, anchor = CENTER);

        // "RATAR" engraved into the interior floor
        floor_label_cut();

        // Heat-set insert holes for the lid's M2 bolts: blind, from the top
        // rim down, centered in X and matching the lid's bolt spacing in Y
        for (y = [-1, 1])
            translate([0, y * lid_bolt_spacing_y / 2, box_height - m2_insert_depth])
                cyl(h = m2_insert_depth + 0.5, d = m2_insert_dia, anchor = BOTTOM);
    }
    translate([cavity_offset_x, 0, 0]) {
        standoffs();
        round_standoffs();
        upper_standoffs();
    }
}

// Two M2 socket-head bolt holes through the lid, centered in X and spaced
// lid_bolt_spacing_y apart in Y -- BOSL2 screw_hole() gives the shank
// clearance and head size from the real ISO M2 spec; counterbore is
// overridden shallow so the socket head sits proud, not flush
module lid_bolt_holes() {
    for (y = [-1, 1])
        translate([0, y * lid_bolt_spacing_y / 2, lid_thickness])
            screw_hole("M2", head = "socket", length = lid_bolt_length,
                       counterbore = m2_counterbore_depth, anchor = "top", orient = UP);
}

// Round lid with a self-centering lip that press-fits into the open top --
// sized to the upper cutout, since that's what now defines the box's mouth
module pcb_box_lid() {
    lip_length = upper_cavity_length - 2 * lip_side_clearance;
    lip_width  = upper_cavity_width - 2 * lip_side_clearance;

    difference() {
        union() {
            outer_shell(lid_thickness);
            translate([upper_cavity_offset_x, 0, 0])
                cuboid([lip_length, lip_width, lip_engage_depth], anchor = TOP);
        }
        lid_bolt_holes();
    }
}

// --- Layout for printing: both parts flat on the bed, side by side ---
gap = 6;

pcb_box_base();

// Lid is modeled lip-down; flip it here so the exported/sliced part is
// already lip-up (flat outer face down on the bed) -- no slicer flip needed
back(outer_dia + gap)
    up(lid_thickness)
        rotate([180, 0, 0])
            pcb_box_lid();

// --- Diagnostics (visible in OpenSCAD console) ---
echo("Outer diameter / height ..", outer_dia, "mm /", box_height, "mm");
echo("Internal cavity (L x W x H)", internal_length, "x", internal_width, "x", internal_height, "mm, shifted", cavity_offset_x, "mm towards +X");
echo("Counterbore flat face ....", counterbore_dia, "mm dia pocket, flat bottom", hole_wall_thickness, "mm thick, pocket depth", outer_radius - flat_bottom_x, "mm");
echo("Board fit clearance ......", side_clearance, "mm per side (L/W)");
echo("Standoff L x D x H .......", standoff_length, "x", standoff_depth, "x", pcb_support_height, "mm, 4 total (2 per 30mm wall), top surface at", floor_thickness + pcb_support_height, "mm above the floor");
echo("Round standoffs ..........", round_standoff_dia, "mm dia x 2, spaced", round_standoff_spacing_y, "mm apart (Y), offset", round_standoff_offset_x, "mm towards the hole wall (X)");
echo("Upper standoffs L x D x H .", standoff_length, "x", standoff_depth, "x", upper_standoff_height, "mm, 4 total, same X offsets as the lower standoffs, top surface at", upper_cavity_z + upper_standoff_height, "mm above the floor");
echo("Side hole dia / height ...", side_hole_dia, "mm, centered at z =", side_hole_z, "mm above the floor (bottom edge", side_hole_z - side_hole_dia / 2, "mm above the floor)");
echo("Upper cutout (L x W) .....", upper_cavity_length, "x", upper_cavity_width, "mm, offset", upper_cavity_offset_x, "mm in X, from z =", upper_cavity_z, "mm up through the top of the base");
echo("USB-C slot (W x H) .......", usb_c_width, "x", usb_c_height, "mm, centered at z =", usb_c_z, "mm (", usb_c_offset_z, "mm above the circular hole's center), shoulder", usb_wall_thickness, "mm thick");
echo("USB-C housing pocket .....", usb_pocket_width, "x", usb_pocket_height, "mm, rounded corners r =", usb_pocket_corner_r, "mm, recessed", usb_pocket_depth, "mm into the outer surface");
echo("Headroom above board .....", top_clearance, "mm (lid lip engages", lip_engage_depth, "mm -- must stay less than headroom)");
echo("Lid M2 bolts ..............", 2, "x M2x", lid_bolt_length, "socket-head (BOSL2 screw_hole), centered in X, spaced", lid_bolt_spacing_y, "mm apart (Y), spot-face depth", m2_counterbore_depth, "mm");
echo("Body heat-set inserts .....", 2, "x", m2_insert_dia, "mm dia x", m2_insert_depth, "mm deep, blind from the top rim, matching the lid bolts");
echo("Print orientation: base and lid flat on the bed as shown, open side / lip facing up.");
