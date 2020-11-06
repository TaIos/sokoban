(define (domain sokoban)

    (:requirements :strips :typing)

    (:types location)

    (:predicates
        (at ?l)
        (path ?l1 ?l2 )
        (is_box_at ?l)
    )

    ; ================================================================================
    ; MOVEMENT
    ; ================================================================================
    (:action walk
        :parameters (?l1 - location ?l2 - location)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (not (is_box_at ?l2))
                        )
        :effect (and
                (at ?l2)
                (not (at ?l1))
                )
    )

    (:action push
        :parameters (?l1 - location ?l2 - location ?l3 - location)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (path ?l2 ?l3)
                        (is_box_at ?l2)
                        (not (is_box_at ?l3))
                        )

        :effect (and
            (at ?l2)
            (not (at ?l1))
            (is_box_at ?l3)
            (not (is_box_at ?l2))
            )
    )

)