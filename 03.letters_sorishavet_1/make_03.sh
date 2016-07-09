#!/bin/bash
cncfc_dir=/home/adam/Documents/00.projects/02.python/cncfc
#cut files mask
PART=03
MOD_SUFIX=2
PART_DIR="part_$PART"
BASE_KNOTS_DIR="$PART_DIR/00.knots"
MODIFIED_KNOTS_DIR="$PART_DIR/01.modif"
GCODE_DIR="$PART_DIR/02.gcode"

BASE_KNOT_PATTERN="????"
PROF_KNOT_PATTERN=????_prof1.knt

KNOT_DOUBLE_1=$BASE_KNOT_PATTERN"d1"
KNOT_DOUBLE_2=$BASE_KNOT_PATTERN"d2"
KNOT_XY=$BASE_KNOT_PATTERN"v?"
KNOT_UV=$BASE_KNOT_PATTERN"u?"
KNOT_FOLD_TOP=$BASE_KNOT_PATTERN"t2"
KNOT_FOLD_SIDE=$BASE_KNOT_PATTERN"s1"
mod_pref=""
cut_xy="xy_"*"$PART""_??.knt"
cut_uv="uv_"*"$PART""_??.knt"
cut_t="$PART"_?t?.knt
cut_c="$PART"_?c?.knt
cut_b="$PART"_?b?.knt
m_cut_t="$mod_pref""$PART"_?t?.knt
m_cut_c="$mod_pref""$PART"_?c?.knt
m_cut_b="$mod_pref""$PART"_?b?.knt

res="$PART*.ngc"
bak="$PART*.bak"
cut="*$PART*$mod_pref*.knt"
res_dir="gcode_"$PART
xyuv_dir="xyuv_"$PART
bak_dir="~bak_"$PART

#if PART dir does not exist, create itss
if [ ! -d "$PART_DIR" ]; then
    mkdir -v "$PART_DIR"
fi

if [ ! -d "$BASE_KNOTS_DIR" ]; then
    mkdir -v "$BASE_KNOTS_DIR"
fi

if [ ! -d "$MODIFIED_KNOTS_DIR" ]; then
    mkdir -v "$MODIFIED_KNOTS_DIR"
fi

if [ ! -d "$GCODE_DIR" ]; then
    mkdir -v "$GCODE_DIR"
fi

#move PART knots to the PART folder
for FILE in $PART*.knt
do
    if [ -f "$FILE" ]; then
        mv -v --backup=numbered  $FILE $BASE_KNOTS_DIR
    fi
done

for FILE in { $BASE_KNOTS_DIR/$KNOT_DOUBLE_1.knt $BASE_KNOTS_DIR/$KNOT_DOUBLE_2.knt }
do
    if [ -f "$FILE" ]; then
        cp -v --backup=numbered  $FILE $MODIFIED_KNOTS_DIR
    fi
done

cd $MODIFIED_KNOTS_DIR

for FILE in { $KNOT_DOUBLE_1.knt $KNOT_DOUBLE_2.knt }
do
    INPUT="$FILE"
    OUTPUT="$FILE"

    output_f="${FILE//d/}" #"${i:8:-3}"

    if [ -f $INPUT ]; then
	$cncfc_dir/knots2gcode.py -i $FILE -o ${output_f:0:-4} -d 418 -cm -sh
    fi
done


#move PART knots to the PART folder
for FILE in $PART*.ngc
do
    if [ -f "$FILE" ]; then
        mv -v --backup=numbered  $FILE ../../$GCODE_DIR
    fi
done
