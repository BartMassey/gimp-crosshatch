; Copyright © 2011 Bart Massey
; Originally a transliteration of a Perl script Copyright © 2001 Sam Jones
; Please see the end of this file for licensing information.
; 
; Makes image appear to have been drawn in and crosshatched.
; Pencil-like and etching-like effects are possible by manipulation
; of the various layers.
; 
; If you are Sam Jones and are reading this, please get in touch
; with me---I would love to talk with you about this code.

(define (script-fu-crosshatch-make-layer image drawable name mode)
  (let ((layer (car (gimp-layer-new
		     image
		     (car (gimp-image-width image))
		     (car (gimp-image-height image))
		     (car (gimp-drawable-type drawable))
		     name
		     100
		     mode))))
    (gimp-image-add-layer image layer -1)
    (gimp-context-set-background '(255 255 255))
    (gimp-edit-fill layer BG-IMAGE-FILL)
    layer))

(define (script-fu-crosshatch-make-etch
	 image drawable name noise etch-length angle darkness)
  (let ((etch (script-fu-crosshatch-make-layer
	       image drawable name NORMAL-MODE)))
    (plug-in-noisify RUN-NONINTERACTIVE image etch 0 noise noise noise 0.0)
    (plug-in-mblur RUN-NONINTERACTIVE image etch 0 etch-length angle 0 0)
    (gimp-layer-set-mode etch GRAIN-MERGE-MODE)
    (gimp-levels etch HISTOGRAM-VALUE (+ darkness 192) 255 1.0 0 255)
    (gimp-layer-set-opacity etch 50)
    etch))
  
(define (script-fu-crosshatch
	 image drawable noise etch-length darkness
	 trace-threshold trace-brush merge-layers)
  (gimp-image-undo-group-start image)
; Grab traceable area for later use
  (gimp-by-color-select drawable '(0 0 0) trace-threshold CHANNEL-OP-REPLACE
			0 0 0.0 0)
  (plug-in-sel2path RUN-NONINTERACTIVE image drawable)
  (gimp-selection-none image)
  (let*
; Trace penciling
      ((o-layer (script-fu-crosshatch-make-layer
		 image drawable "Traced Outline" MULTIPLY-MODE))
; The crosshatching is two layers 90 degrees apart
       (e-layer (script-fu-crosshatch-make-etch
		 image drawable "Etch" noise etch-length 135 darkness))
       (ce-layer (script-fu-crosshatch-make-etch
		  image drawable "Cross Etch" noise etch-length 45 darkness)))

    (gimp-context-set-brush (car trace-brush))
    (gimp-context-set-opacity (* 100 (cadr trace-brush)))
    (gimp-context-set-paint-mode (cadddr trace-brush))
    (gimp-edit-stroke-vectors o-layer
			      (car (gimp-image-get-active-vectors image)))
    (gimp-layer-set-opacity o-layer 50)
    (if (eq? merge-layers TRUE)
	(begin
	  (gimp-image-merge-down image o-layer CLIP-TO-IMAGE)
	  (gimp-image-merge-down image e-layer CLIP-TO-IMAGE)
	  (gimp-image-merge-down image ce-layer CLIP-TO-IMAGE))))
  
; Clean up
  (gimp-image-undo-group-end image)
  (gimp-displays-flush))

(script-fu-register
 "script-fu-crosshatch"
 "Cross_hatch..."
 "Makes image appear to have been drawn in and crosshatched"
 "Sam Jones, Bart Massey"
 "Copyright 2001 Sam Jones; Copyright 2011 Bart Massey"
 "April 16, 2001"
 "RGB* GRAY*"
 SF-IMAGE "Image" 0
 SF-DRAWABLE "Drawable" 0
 SF-ADJUSTMENT "Etch density" `(0.25 0.0 1.0 0.05 0.25 2 ,SF-SLIDER)
 SF-ADJUSTMENT "Etch length" `(10.0 0.0 100.0 1.0 5.0 1 ,SF-SLIDER)
 SF-ADJUSTMENT "Sketch darkness" `(31 0 63 1 8 0 ,SF-SLIDER)
 SF-ADJUSTMENT "Trace threshold" `(40 0 255 1 16 0 ,SF-SLIDER)
 SF-BRUSH  "Trace brush" `("Diagonal Star (11)" 1.0 100 ,NORMAL)
 SF-TOGGLE "Merge layers" TRUE)

(script-fu-menu-register
 "script-fu-crosshatch"
 "<Image>/Filters/Artistic")

;   This program is free software; you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation; either version 2 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License along
;   with this program; if not, write to the Free Software Foundation, Inc.,
;   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
