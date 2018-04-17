(in-package #:daft)

;;------------------------------------------------------------

(defconstant +max-actor-count+ 20000)
(defparameter *screen-height-in-game-units* 600f0)
(defvar *actor-kinds* (make-hash-table))
(defvar *blend-params* (make-blending-params))
(defvar *god* nil)
(defvar *instanced-cube-stream* nil)
(defvar *per-actor-c-data* nil)
(defvar *per-actor-data* nil)
(defvar *sdl2-pads* nil)
(defvar *self*)
(defvar *tasks-for-next-frame* nil)
(defvar *ssbo* nil)
(defvar *default-z-offset* -10f0)
(defvar *world-empty-fbo* nil)
(defvar *world-size* (v! 2048 2048))
(defvar *world-viewport* (make-viewport *world-size*))

;;------------------------------------------------------------
