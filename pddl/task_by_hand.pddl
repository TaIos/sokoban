(define (problem sokoban_path)
   (:domain sokoban)
    (:requirements :strips :typing )
   (:objects
       01-01 02-02 - location
   )
   (:init

        ; ================================================================================
        ; PATH
        ; ================================================================================
        (path 01-01 02-02)         (path 02-02 01-01)

        ; ================================================================================
        ; BOX
        ; ================================================================================
        (is_box_at 01-01)

        ; ================================================================================
        ; PLAYER
        ; ================================================================================
        (at 02-02)

   )
   (:goal  (is_box_at 02-02))

)