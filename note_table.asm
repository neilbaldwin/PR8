
periodLo:
.IF PAL_VERSION=1
  .byte $60,$f6,$92,$34,$db,$86,$37,$ec,$a5,$62,$23,$e8
  .byte $b0,$7b,$49,$19,$ed,$c3,$9b,$75,$52,$31,$11,$f3
  .byte $d7,$bd,$a4,$8c,$76,$61,$4d,$3a,$29,$18,$08,$f9
  .byte $eb,$de,$d1,$c6,$ba,$b0,$a6,$9d,$94,$8b,$84,$7c
  .byte $75,$6e,$68,$62,$5d,$57,$52,$4e,$49,$45,$41,$3e
  .byte $3a,$37,$34,$31,$2e,$2b,$29,$26,$24,$22,$20,$1e
.ELSE
  .byte $f1,$7f,$13,$ad,$4d,$f3,$9d,$4c,$00,$b8,$74,$34
  .byte $f8,$bf,$89,$56,$26,$f9,$ce,$a6,$80,$5c,$3a,$1a
  .byte $fb,$df,$c4,$ab,$93,$7c,$67,$52,$3f,$2d,$1c,$0c
  .byte $fd,$ef,$e1,$d5,$c9,$bd,$b3,$a9,$9f,$96,$8e,$86
  .byte $7e,$77,$70,$6a,$64,$5e,$59,$54,$4f,$4b,$46,$42
  .byte $3f,$3b,$38,$34,$31,$2f,$2c,$29,$27,$25,$23,$21
  .byte $1f,$1d,$1b,$1a,$18,$17,$15,$14,$13,$12,$11,$10
  .byte $0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04
.ENDIF

periodHi:
.IF PAL_VERSION=1
  .byte $07,$06,$06,$06,$05,$05,$05,$04,$04,$04,$04,$03
  .byte $03,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02,$01
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.ELSE
  .byte $07,$07,$07,$06,$06,$05,$05,$05,$05,$04,$04,$04
  .byte $03,$03,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.ENDIF