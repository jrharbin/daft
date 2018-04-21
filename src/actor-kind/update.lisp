(in-package :daft)

;;------------------------------------------------------------

(defun update-actor-kinds (scene)
  (with-slots (kinds) scene
    ;;
    (do-hash-vals actor-kind kinds
      (reset-surviving-actor-array actor-kind))
    ;;
    (do-hash-vals actor-kind kinds
      (unless (static-p actor-kind)
        (clrhash (kinds-to-test-collision-with actor-kind))
        (loop
           :for actor :across (this-frames-actors actor-kind)
           :do
           (copy-actor-state actor)
           (update actor)
           (if (slot-value actor 'dead)
               (free-actor actor)
               (enqueue-actor-for-next-frame actor)))))
    ;;
    (do-hash-vals actor-kind (kinds scene)
      (when (dirty-p actor-kind)
        (write-per-actor-data actor-kind)))))

(defun reset-surviving-actor-array (actor-kind)
  (setf (fill-pointer (next-frames-actors actor-kind)) 0))

(defun enqueue-actor-for-next-frame (actor)
  (with-slots (kind) actor
    (vector-push-extend actor (next-frames-actors kind))))

(defun write-per-actor-data (actor-kind)
  (with-slots (per-actor-c-data
               per-actor-gpu-data
               per-actor-c-len)
      actor-kind
    (let ((count 0))
      (when (slot-value actor-kind 'visual)
        (loop
           :for actor :across (this-frames-actors actor-kind)
           :do
           (when (not (slot-value actor 'dead))
             (write-actor-data actor per-actor-c-data count)
             (setf (id actor) count)
             (incf count)))
        (when (> count 0)
          (push-g (subseq-c per-actor-c-data 0 count)
                  (subseq-g per-actor-gpu-data 0 count))))
      (setf per-actor-c-len count)
      actor-kind)))

(defun draw-actor-kinds (scene res)
  (with-setf* ((clear-color) (v! 0 0 0 0))
    (do-hash-vals actor-kind (kinds scene)
      (with-slots (collision-fbo
                   per-actor-c-data
                   per-actor-gpu-data
                   per-actor-c-len
                   dirty-p)
          actor-kind
        (when dirty-p
          (clear-fbo (collision-fbo actor-kind)))
        (when (> per-actor-c-len 0)
          (draw-actors-to-screen scene
                                 actor-kind
                                 per-actor-c-len
                                 res)
          (when dirty-p
            (clear-fbo (collision-fbo actor-kind))
            (draw-actors-collision-mask scene
                                        actor-kind
                                        per-actor-c-len
                                        res)))))
    (do-hash-vals actor-kind (kinds scene)
      (with-slots (collision-fbo
                   per-actor-c-data
                   per-actor-gpu-data
                   per-actor-c-len
                   static-p
                   dirty-p)
          actor-kind
        (when (> per-actor-c-len 0)
          (unless static-p
            (run-collision-checks scene
                                  actor-kind
                                  per-actor-c-len
                                  res)))))))

(defun mark-actors-clean (scene)
  (do-hash-vals actor-kind (kinds scene)
    (when (and (dirty-p actor-kind)
               (static-p actor-kind))
      (setf (dirty-p actor-kind) nil))))

(defun rotate-actor-kind-state (scene)
  (do-hash-vals actor-kind (kinds scene)
    (unless (static-p actor-kind)
      (loop :for actor :across (this-frames-actors actor-kind) :do
         (rotate-actor-state actor))
      (rotatef (this-frames-actors actor-kind) (next-frames-actors actor-kind)))))

;;------------------------------------------------------------

(defun ensure-god ()
  (unless *god*
    (let ((*self* nil))
      (setf *god* (spawn 'god (v! 0 0))))))
