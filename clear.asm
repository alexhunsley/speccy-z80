; This is where your program starts in RAM.
org 40000

	jr blocks
; Clear the screen to black.
    ld a,110         ; White ink (7), black paper (0), bright (64).
    ld (23693),a    ; Set our screen colours.
    xor a           ; Load accumulator with zero.
    call 8859       ; Set permanent border colours.
    call 3503       ; Clear the screen, open channel 2.

blocks
; try setting some attribs

    ld b,32  ; attribute byte - go through all paint, Flash, Bright combos (must shift this value left three bits)
    ld HL,22528  ; colour attribute memory start
    ld de,4  ; x stride for blocks plotted
plot
	ld c,b  ;
	rl c    ;
	rl c    ;
	rl c    ; do attrib << 3 into c
	ld (HL),c  ; set attrib on memory
    add hl,de  ; add the x stride
    call pause  ; slow down the block drawing so it's visible
    djnz plot  ; loop on b -> 0

pause
      push bc   ; preserve b
      ld b,25            ; time to pause in 50ths of a sec
delay halt                ; wait for next interrupt to finish being serviced
      djnz delay          ; repeat.
      pop bc
      ret

text
;.DB "Hello",0
DEFM 11,"HELLO WORLD"
DEFB 0

; Pasmo needs this to know where to start running your program from.
; It should be the same as the address you specified at the top!
end 40000

