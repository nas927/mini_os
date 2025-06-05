SECTOR_SIZE equ 512
LOAD_SEGMENT equ 0x1000     ; Segment où charger les données
LOAD_OFFSET equ 0x0000
msg_error db "Erreur disque!", 13, 10, 0
msg_found db "Fichier trouve!", 13, 10, 0
msg_not_found db "Fichier non trouve!", 13, 10, 0
; === FICHIER A CHERCHER ===
target_filename db "kernel.c", 0  ; Nom du fichier (format 8.3, espaces pour padding)

load_sector_2:
    mov ah, 0x02        ; Fonction lecture secteur
    mov al, 1           ; Nombre de secteurs à lire
    mov ch, 0           ; Cylindre 0
    mov cl, 2           ; Secteur 2 (commence à 1)
    mov dh, 0           ; Tête 0
    mov dl, 0x80        ; Premier disque dur (0x00 pour floppy)
    
    ; Adresse de destination
    mov bx, LOAD_SEGMENT
    mov es, bx
    mov bx, LOAD_OFFSET
    
    int 0x13            ; Appel BIOS
    jc .error           ; Si erreur (carry flag set)
    
    ret
    
.error:
    mov si, msg_error
    call print_char
    ret


