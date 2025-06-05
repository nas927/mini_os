; pour savoir les signatures et aller plus loin allez ici : https://dev.to/frosnerd/writing-my-own-boot-loader-3mld
bits 16
org 0x7C00              ; Adresse mémoire où le BIOS charge le bootloader


start:
    xor ax, ax          ; initialise à 0 registre de 16 bits l'objet d'un prochain post
    mov ds, ax

    mov ax, 65535
    call print_number

    call load_sector_2

    in al, 0x92
    or al, 2
    out 0x92, al

    call get_a20_state
    call print_number

    jmp done

done:
    hlt
    jmp $               ; $ stock l'adresse du début


message db "yoo", 0dh, 0ah, 0     ; 0 à la fin va servir à comprendre qu'on est en fin de chaine sinon il va lire plus loin dans la mémoire 
error_file db "fichier non trouve !", 0

%include "utils.nasm"
%include "disk.nasm"
%include "protect_mode.nasm"

; Remplissage jusqu'à 510 octets
times 510 - ($ - $$) db 0
dw 0xAA55               ; Signature de boot (2 octets à la fin)

times (2048 - 1) * 512 db 0 ; ajout d'octet en multiple de 512 pour pouvoir transformer notre .bin en .vdi
