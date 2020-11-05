(define (domain sailor)

    (:requirements :strips :typing)

    (:types location item)

    (:predicates
        (at ?l ?i)
        (path ?l1 ?l2)
        (free ?l)
    )

    ; ================================================================================
    ; MOVEMENT
    ; ================================================================================
    (:action walk
        :parameters (?l1 - location ?l2 - location)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (not (actionRestrict ?l2))
                        (isLand ?l1) (isLand ?l2))
        :effect (and (at ?l2)(not (at ?l1)))
    )

    (:action push
        :parameters (?l1 - location ?l2 - location ?ship - item)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (own ?ship)
                        (isShip ?ship)
                        (not (actionRestrict ?l2))
                        (not (and (not (isSea ?l1)) (not (isSea ?l2)))))
        :effect (and (at ?l2) (not (at ?l1)))
    )

    ;--------------------
    ;MOVEMENT TO MORE

    ; JOIN
    (:action sailToSea_JoinPirates
        :parameters (?l1 - location ?l2 - location ?ship - item)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (actionRestrict ?l2)
                        (own ?ship)
                        (isShip ?ship)
                        (not (and (not (isSea ?l1)) (not (isSea ?l2))))
                        (hasPochybneZnamosti)
                        (atJoinPirates ?l2))
        :effect (and
                (nameteny)
                (at ?l2) (not (at ?l1)))
        )

    ; LOSE
    (:action sailToSea_LosePirateAmbush
        :parameters (   ?l1 - location ?l2 - location
                        ?ship - item ?rescue - item
                        ?lose1 - item ?lose2 - item ?lose3 - item
                        ?lose4 - item ?lose5 - item ?lose6 - item)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (actionRestrict ?l2)
                        (own ?ship)
                        (isShip ?ship)
                        (isShip ?rescue)
                        (not (and (not (isSea ?l1)) (not (isSea ?l2))))
                        (not (zoceleny))
                        (atPirateAmbush ?l2 ?lose1 ?lose2 ?lose3 ?lose4 ?lose5 ?lose6 ?rescue))
        :effect (and
                (at ?l2) (not (at ?l1))
                (zoceleny)
                (own ?rescue)
                (not (own ?lose1)) (not (own ?lose2)) (not (own ?lose3))
                (not (own ?lose4)) (not (own ?lose5)) (not (own ?lose6)))
    )

    ;WIN
    (:action sailToSea_WinPirateAmbush
        :parameters (   ?l1 - location ?l2 - location
                        ?ship - item ?rescue - item
                        ?reward1 - item ?reward2 - item ?reward3 - item
                        ?reward4 - item ?reward5 - item ?reward6_karavela - item)
        :precondition (and
                        (at ?l1)
                        (path ?l1 ?l2)
                        (actionRestrict ?l2)
                        (own ?ship)
                        (isShip ?ship)
                        (isShip ?rescue)
                        (not (and (not (isSea ?l1)) (not (isSea ?l2))))
                        (zoceleny)
                        (own ?reward6_karavela)
                        (atPirateAmbush ?l2 ?reward1 ?reward2 ?reward3 ?reward4 ?reward5 ?reward6_karavela ?rescue))
        :effect (and
                (at ?l2) (not (at ?l1))
                (defeatedPirates)
                (own ?rescue)
                (own ?reward1) (own ?reward2) (own ?reward3)
                (own ?reward4) (own ?reward5) (own ?reward6_karavela))
    )

    ; ================================================================================
    ; CRAFTING
    ; ================================================================================
    (:action craft1
        :parameters (?want - item ?required - item)
        :precondition (and
                        (own ?required)
                        (craftable1 ?want ?required))
        :effect (and (own ?want) (not (own ?required)))
    )

    (:action craft2
        :parameters (?want - item ?required1 - item ?required2 - item)
        :precondition (and
                        (own ?required1) (own ?required2)
                        (craftable2 ?want ?required1 ?required2))
        :effect (and (own ?want) (not (own ?required1)) (not (own ?required2)))
    )

    (:action craft3
        :parameters (?want - item ?required1 - item ?required2 - item ?required3 - item)
        :precondition (and
                        (own ?required1) (own ?required2) (own ?required3)
                        (craftable3 ?want ?required1 ?required2 ?required3))
        :effect (and (own ?want) (not (own ?required1)) (not (own ?required2)) (not (own ?required3)))
    )

    ; ================================================================================
    ; DRINKING
    ; ================================================================================
    (:action drink
        :parameters (?a - item)
        :precondition (and
                        (own ?a)
                        (isAlcohol ?a))
        :effect (and (not (own ?a)) (nameteny))
    )

    (:action drinkHard
        :parameters (?a - item)
        :precondition (and
                        (own ?a)
                        (isAlcohol ?a)
                        (nameteny))
        :effect (and (not (own ?a)) (opily))
    )

    (:action drinkHardHard
        :parameters (?a - item)
        :precondition (and
                        (own ?a)
                        (isAlcohol ?a)
                        (opily))
        :effect (and (not (own ?a)) (zavisly))
    )

    ; ================================================================================
    ; LOCATION ACTIONS
    ; ================================================================================

    ;--------------------
    ; COMMON
    (:action collectItem
        :parameters (?l - location ?i - item)
        :precondition (and
                        (at ?l)
                        (resource ?l ?i))
        :effect (and (own ?i))
    )

    (:action steal
        :parameters (?l - location ?i - item)
        :precondition (and
                        (at ?l)
                        (canSteal ?l ?i))
        :effect (and (own ?i) (hasCriminalRecord))
    )

    (:action getSober
        :parameters (?l - location)
        :precondition (and
                        (at ?l)
                        (canGetSober ?l))
        :effect (and (not (nameteny)) (not (opily)) (not (zavisly)))
    )

    (:action trade
        :parameters (?l - location ?have - item ?want - item)
        :precondition (and
                        (at ?l)
                        (own ?have)
                        (canTrade ?l ?have ?want))
        :effect (and (not (own ?have)) (own ?want))
    )

    (:action tradeWithContacts
        :parameters (?l - location ?have - item ?want - item)
        :precondition (and
                        (at ?l)
                        (own ?have)
                        (canTradeWithContacts ?l ?have ?want))
        :effect (and (not (own ?have)) (own ?want) (hasDobreZnamosti))
    )

    ;--------------------
    ; LES
    (:action fightBear
        :parameters (?l - location ?reward - item)
        :precondition (and
                        (at ?l)
                        (atBear ?l ?reward))
        :effect (and (own ?reward) (zoceleny) (defeatedBear) )
    )

    (:action meetMagicGrandpa
        :parameters (?l - location ?a - item)
        :precondition (and
                        (at ?l)
                        (own ?a)
                        (isAlcohol ?a)
                        (atMagicGrandpa ?l))
        :effect (and (not (own ?a)) (hasMap) (hasPochybneZnamosti) )
    )

    ;--------------------
    ; REKA

    ;--------------------
    ; PRISTAV
    (:action meetSmugglers
        :parameters (?l - location ?required - item)
        :precondition (and
                        (at ?l)
                        (own ?required)
                        (hasPochybneZnamosti)
                        (atSmugglers ?l ?required))
        :effect (and (hasSmugglersContact))
    )

    ;--------------------
    ; HOSPODA
    (:action payRund
        :parameters (?l - location ?required - item)
        :precondition (and
                        (at ?l)
                        (own ?required)
                        (atPayRund ?l ?required))
        :effect (and (not (own ?required)) (hasDobreZnamosti))
    )

    (:action zocelitBitce
        :parameters (?l - location)
        :precondition (and
                        (at ?l)
                        (nameteny)
                        (atZocelitBitce ?l))
        :effect (and (zoceleny))
    )

    ;--------------------
    ; MESTO
    (:action buyOdpustek
        :parameters (?l - location ?required - item)
        :precondition (and
                        (at ?l)
                        (own ?required)
                        (canBuyOdpustek ?l ?required))
        :effect (and (not (hasCriminalRecord)) (not (own ?required)))
    )

    (:action doCommunityService
        :parameters (?l - location)
        :precondition (and
                        (at ?l)
                        (atCommunityService ?l))
        :effect (and (not (hasCriminalRecord)) (nameteny))
    )

    ;--------------------
    ;NAMORNI AKADEMIE
    (:action goToAcademy
        :parameters (?l - location ?required - item)
        :precondition (and
                        (at ?l)
                        (own ?required)
                        (not (hasCriminalRecord))
                        (atGoToAcademy ?l ?required))
        :effect (and (not (own ?required)) (isCapitan) )
    )

    ;--------------------
    ;MORE

    ;--------------------
    ;MAJAK
    (:action oslnitDivku
        :parameters (?l - location)
        :precondition (and
                        (at ?l)
                        (atDivka ?l)
                        (not (and (not(defeatedPirates)) (not (defeatedBear)) (not (isCapitan)))))
        :effect (and (oslnilDivku))
    )

    ;--------------------
    ;OSTROV
    (:action plunderCocainHideout
        :parameters (?l - location)
        :precondition (and
                        (at ?l)
                        (hasMap)
                        (atCocain ?l))
        :effect (and (plunderedCocainHideout))
    )

    ; ================================================================================
    ; ENDING CONDITIONS
    ; ================================================================================

    (:action marry
        :parameters (?l - location ?required1 - item ?required2 - item )
        :precondition (and
                        (at ?l)
                        (own ?required1) (own ?required2)
                        (atMarryConditions ?l ?required1 ?required2)
                        (oslnilDivku)
                        (hasDobreZnamosti)
                        (not (hasCriminalRecord))
                        (not (opily))
                        (not (zavisly)) )
        :effect (and (journeyEnd) (test_marry))
    )

    (:action beAdrimal
        :parameters (?l - location)
        :precondition (and
                        (at ?l)
                        (atCaptainConditions ?l)
                        (isCapitan)
                        (defeatedPirates)
                        (not (nameteny))
                        (not (opily))
                        (not (zavisly)))
        :effect (and (journeyEnd) (test_admiral))
    )

    (:action beCocaineAddict
        :parameters (?required1 - item ?required2 - item)
        :precondition (and
                        (atCocainConditions ?required1 ?required2)
                        (own ?required1) (own ?required2)
                        (plunderedCocainHideout)
                        (hasSmugglersContact)
                        (zavisly))
        :effect (and (journeyEnd) (test_addict))
    )
)