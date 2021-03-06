(in-package :daft)

;;------------------------------------------------------------

(defun next-frame (&optional range)
  (let ((start-frame (if range
                         (first range)
                         0))
        (anim-length (if range
                         (second range)
                         (slot-value *self* 'anim-length))))
    (with-slots (anim-frame) *self*
      (let ((frame (- anim-frame start-frame)))
        (setf anim-frame
              (float (+ (mod (+ (floor frame) 1)
                             anim-length)
                        start-frame)
                     0f0))))))

(defun advance-frame (amount &optional range)
  (let ((start-frame (if range
                         (first range)
                         0))
        (anim-length (if range
                         (second range)
                         (slot-value *self* 'anim-length))))
    (with-slots (anim-frame) *self*
      (let ((frame (- anim-frame start-frame)))
        (setf anim-frame
              (float (+ (mod (+ frame amount)
                             anim-length)
                        start-frame)
                     0f0))))))

;;------------------------------------------------------------
