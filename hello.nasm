bits 16
org 0x7C00              ; Adresse mémoire où le BIOS charge le bootloader

start:
    cli                 ; Désactive les interruptions
    xor ax, ax
    mov ds, ax          ; Initialise le segment data à 0x0000

    mov si, message     ; Pointeur sur la chaîne à afficher

.print_char:
    lodsb               ; Charge un octet depuis [SI] dans AL, SI++
    cmp al, 0
    je .done            ; Fin de chaîne si caractère nul

    mov ah, 0x0E        ; Fonction "afficher un caractère" du BIOS
    int 0x10            ; Appel BIOS

    jmp .print_char

.done:
    hlt                 ; Boucle ici après affichage (évite de faire n'importe quoi)
    jmp $

message db "ok fait!", 0

; Remplissage jusqu'à 510 octets
times 510 - ($ - $$) db 0
dw 0xAA55               ; Signature de boot (2 octets à la fin)

times (2048 - 1) * 512 db 0
