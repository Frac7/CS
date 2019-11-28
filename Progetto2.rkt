#lang bitml
;members of the jury
(participant "A" "0339bd7fade9167e09681d68c5fc80b72166fe55bbb84211fd12bde1d57247fbe1")
(participant "B" "021927aa11df2776adc8fde8f36c4f7116dbfb466d6c2cd500ae3eabc0fcfb0a33")
(participant "C" "034a7192e922118173906555a39f28fa1e0b65657fc7f403094da4f85701a5f809")
;defendant
(participant "S" "034a7192e922118173906555a39f28fa1e0b65657fc7f403094da4f85701a5f829")
;tribunal
(participant "T" "028eaf05685be45c575213a9a1da1625bc4f9ae1dba4f6561b8da5482d46462493")
;Curator
(participant "Cur" "037748ca8286d29d53fdc07df0f5b9a734b3d033800ff806952a5e9cad66e5aaef")

(debug-mode)

(define (deadline) 160000000)

(define (twoAgree)
  (split
   (0.9 -> (choice
            (auth "Cur" (withdraw "T"))
            (after (ref(deadline)) (auth "Cur"(withdraw "S")))
            ))
   (0.1 -> (withdraw "Cur"))
   ))

(contract
 (pre (deposit "A" 1 "txid:something@0"))

 (choice
  (auth "A" "B" (ref(twoAgree)))
  (auth "A" "C" (ref(twoAgree)))
  (auth "C" "B" (ref(twoAgree)))
  )
  
(check-liquid
 (strategy "A" (do-auth))
 (strategy "B" (do-auth))
 (strategy "Cur" (do-auth ))
 )

 (check "Cur" has-at-least 0.1
   (strategy "A" (do-auth))
 (strategy "B" (do-auth))
 (strategy "Cur" (do-auth ))
  
 )

 )
  