(in-package #:daft)

;;------------------------------------------------------------

(defconstant +max-actor-count+ 20000)
(defparameter *screen-height-in-game-units* 600f0)
(defvar *blend-params* (make-blending-params))
(defvar *god* nil)
(defvar *instanced-cube-stream* nil)
(defvar *per-actor-data* nil)
(defvar *sdl2-pads* nil)
(defvar *self*)
(defvar *tasks-for-next-frame* nil)
(defvar *ssbo* nil)
(defvar *default-z-offset* -10f0)
(defvar *current-scene* nil)
(defvar *audio-initialized* nil)

;;------------------------------------------------------------
