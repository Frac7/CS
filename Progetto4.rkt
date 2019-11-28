;The contract is similar to the second one,
;but if the curator opposes the decision of the jury,
;there is another round of judgment. The second round is performed by a second jury.
;If the curator opposes the decision of the second jury,
;the seized bitcoin goes to the tribunal.

#lang bitml
;members of the jury 1
(participant "A1" "0339bd7fade9167e09681d68c5fc80b72166fe55bbb84211fd12bde1d57247fbe1")
(participant "B1" "021927aa11df2776adc8fde8f36c4f7116dbfb466d6c2cd500ae3eabc0fcfb0a33")
(participant "C1" "034a7192e922118173906555a39f28fa1e0b65657fc7f403094da4f85701a5f809")
;members of the jury 2
(participant "A2" "038cf2741f2b20be5ef1128e33402d4f90aee5bac77c5e2a36f92af75ebfdf56c8")
(participant "B2" "036e9896d369d88f39c942b424aae94f02ecaed05732bb7565ea7170e8f6dd4ad4")
(participant "C2" "02061d040be9d680f0ed43776331769076b0af9a9bbd3002926d156356ba95db91")
;defendant
(participant "S" "034a7192e922118173906555a39f28fa1e0b65657fc7f403094da4f85701a5f829")
;tribunal
(participant "T" "028eaf05685be45c575213a9a1da1625bc4f9ae1dba4f6561b8da5482d46462493")
;Curator
(participant "Cur" "037748ca8286d29d53fdc07df0f5b9a734b3d033800ff806952a5e9cad66e5aaef")

(debug-mode)

(define (deadline) 160000000)

(define (twoAgree)

   (tau (choice
            (auth "Cur" (withdraw "T"))
            (after (ref(deadline)) (withdraw "S"))
            ))
   )

(define (notFirstRound)
  (split
   (0.9 -> (choice
            (auth "Cur" (tau(choice
                             (auth "A2" "B2" (ref(twoAgree)))
                             (auth "A2" "C2" (ref(twoAgree)))
                             (auth "C2" "B2" (ref(twoAgree)))
                             )))
            (after (ref(deadline)) (withdraw "S"))
            ))
   (0.1 -> (withdraw "Cur"))
   )
  )

(contract
 (pre (deposit "A1" 1 "txid:something@0"))

 (choice
  (auth "A1" "B1" (ref(notFirstRound)))
  (auth "A1" "C1" (ref(notFirstRound)))
  (auth "C1" "B1" (ref(notFirstRound)))
  )
  
 #;(check-liquid
  (strategy "A1" (do-auth))
  (strategy "B1" (do-auth))
  (strategy "A2" (do-auth))
  (strategy "B2" (do-auth))
  (strategy "Cur" (do-auth ))
  )

 ;(check "Cur" has-at-least 0.1
  ;      (strategy "A1" (do-auth))
   ;     (strategy "B1" (do-auth))
    ;    (strategy "Cur" (do-auth ))
  
     ;   )

 )
