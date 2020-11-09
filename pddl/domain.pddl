(define (domain sokoban)

    (:requirements :strips :typing)

    (:types location)

    (:predicates
        (at ?l)
        (is_box_at ?l)
        (path-left ?l1 ?l2)
        (path-right ?l1 ?l2)
        (path-up ?l1 ?l2)
        (path-down ?l1 ?l2)
    )

    ; ================================================================================
    ; MOVEMENT
    ; ================================================================================
    (:action walk-right
        :parameters (?l1 - location ?l2 - location)
        :precondition (and
                        (at ?l1)
                        (path-right ?l1 ?l2)
                        (not (is_box_at ?l2))
                        )
        :effect (and
                (at ?l2)
                (not (at ?l1))
                )
    )

    (:action walk-left
        :parameters (?l1 - location ?l2 - location)
        :precondition (and
                        (at ?l1)
                        (path-left ?l1 ?l2)
                        (not (is_box_at ?l2))
                        )
        :effect (and
                (at ?l2)
                (not (at ?l1))
                )
    )

    (:action walk-down
        :parameters (?l1 - location ?l2 - location)
        :precondition (and
                        (at ?l1)
                        (path-down ?l1 ?l2)
                        (not (is_box_at ?l2))
                        )
        :effect (and
                (at ?l2)
                (not (at ?l1))
                )
    )

    (:action walk-up
        :parameters (?l1 - location ?l2 - location)
        :precondition (and
                        (at ?l1)
                        (path-up ?l1 ?l2)
                        (not (is_box_at ?l2))
                        )
        :effect (and
                (at ?l2)
                (not (at ?l1))
                )
    )

    (:action push-left
        :parameters (?l1 - location ?l2 - location ?l3 - location)
        :precondition (and
                        (at ?l1)
                        (is_box_at ?l2)
                        (not (is_box_at ?l3))
                        (path-left ?l1 ?l2)
                        (path-left ?l2 ?l3)
                        )

        :effect (and
            (at ?l2)
            (not (at ?l1))
            (is_box_at ?l3)
            (not (is_box_at ?l2))
            )
    )

    (:action push-right
        :parameters (?l1 - location ?l2 - location ?l3 - location)
        :precondition (and
                        (at ?l1)
                        (is_box_at ?l2)
                        (not (is_box_at ?l3))
                        (path-right ?l1 ?l2)
                        (path-right ?l2 ?l3)
                        )

        :effect (and
            (at ?l2)
            (not (at ?l1))
            (is_box_at ?l3)
            (not (is_box_at ?l2))
            )
    )

    (:action push-up
        :parameters (?l1 - location ?l2 - location ?l3 - location)
        :precondition (and
                        (at ?l1)
                        (is_box_at ?l2)
                        (not (is_box_at ?l3))
                        (path-up ?l1 ?l2)
                        (path-up ?l2 ?l3)
                        )

        :effect (and
            (at ?l2)
            (not (at ?l1))
            (is_box_at ?l3)
            (not (is_box_at ?l2))
            )
    )

    (:action push-down
        :parameters (?l1 - location ?l2 - location ?l3 - location)
        :precondition (and
                        (at ?l1)
                        (is_box_at ?l2)
                        (not (is_box_at ?l3))
                        (path-down ?l1 ?l2)
                        (path-down ?l2 ?l3)
                        )

        :effect (and
            (at ?l2)
            (not (at ?l1))
            (is_box_at ?l3)
            (not (is_box_at ?l2))
            )
    )


)