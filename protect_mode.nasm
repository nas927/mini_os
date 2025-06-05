get_a20_state:
pushf  								; envoie sur la stack le flag ça sert pour les résultat de l'instruction cmp par exemple
	push si 						; envoie sur la stack le pointer si pour le récupérer plus tard et revenir
	push di 						; etc
	push ds
	push es
	cli								; désactive les interruptions

	mov ax, 0x0000					; 0x0000:0x0500(0x00000500) -> ds:si
	mov ds, ax						; ax -> ds
	mov si, 0x0500					; met 0x0500 dans si	

    not ax						    ; not inverse ax = 0xffff
	mov es, ax						; ax dans es
	mov di, 0x0510					; di = 0x0510

	mov al, [ds:si]					; enregistre les anciennes valeurs contenu à l'adresse 0x00000:0x0500
	mov byte [.BufferBelowMB], al	; enregistre al dans .BufferBelwMb
	mov al, [es:di]					; enregistre la valeur de l'adresse 0x00000:0x0510
	mov byte [.BufferOverMB], al    ; enregistre al dans .BufferOverMB

	mov ah, 1						; place  1 à ah
	mov byte [ds:si], 0				; met l'octet 0 = valeur de l'adresse 0x0000:0x0500
	mov byte [es:di], 1				; met l'octet 1 = valeur de l'adresse 0xFFFF:0x0510
	mov al, [ds:si]					; place la valeur de l'adresse 0x0000:0x0500 dans al
	cmp al, [es:di]					; compare l'octet à l'adresse 0x0000:0x0500 et 0xFFFF:0x0510
	jne .exit						; si c'est pas égale on va dans exit
	dec ah							; décrémenter ah ah = ah - 1
.exit:
	mov al, [.BufferBelowMB]		; stock la valeur de .BufferBelowMb dans al
	mov [ds:si], al					; place la valeur de al à l'adresse 0x0000:0x0500
	mov al, [.BufferOverMB]			; stock la valeur de .BufferOverMb dans al
	mov [es:di], al					; place la valeur de al à l'adresse 0xFFFF:0x0510
	shr ax, 8						; place le résultat de ah vers le registre al et clear ah
	sti								; contraire de cli
	pop es							; retirer de la pile et mettre dans es
	pop ds							; etc
	pop di
	pop si
	popf							; retirer les flags de la pile
	ret								; return pour ne pas executerla suite
	
	.BufferBelowMB:	db 0
	.BufferOverMB	db 0