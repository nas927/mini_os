print_char:
    lodsb               ; Charge un octet depuis [SI] dans AL, SI++ on stock donc dans al comme argument de la fonction 0x0E
    cmp al, 0           ; compare le contenu de al avec 0   
    je .fin             ; Fin de chaîne si caractère nul

    mov ah, 0x0E        ; Fonction "afficher un caractère" du BIOS : https://wiki.osdev.org/index.php?search=0x0e&title=Special%3ASearch&go=Go
    int 0x10            ; Appel BIOS ici https://wiki.osdev.org/BIOS

    jmp print_char      ; jmp sauter/aller vers .print_char

.fin:
    ret

; mov ax, number
print_number:
    mov bx, 10          ; Diviseur (base 10)
    
    ; Sauvegarder la pile pour stocker les chiffres
    push bp
    mov bp, sp
    
.divide_loop:
    xor dx, dx          ; Nettoyer DX pour la division = 0
    div bx              ; Divise AX par BX, quotient dans AX, reste dans DX
    add dx, '0'         ; Convertir le reste en ASCII
    push dx             ; Sauvegarder le chiffre
    
    test ax, ax         ; Vérifier si le quotient est 0
    jnz .divide_loop    ; Si non, continuer la division
    
.print_loop:
    pop ax              ; Récupérer un chiffre
    mov ah, 0x0E        ; ²Fonction BIOS pour afficher
    int 0x10            ; Appel BIOS
    
    cmp sp, bp          ; Vérifier si on a affiché tous les chiffres
    jne .print_loop     ; Si non, continuer

    new_line db 0dh, 0ah, 0
    mov si, new_line
    call print_char
    
    pop bp              ; Restaurer BP
    ret