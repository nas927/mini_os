void kernel_main(void) {
    const char* msg = "Hello from C kernel!";
    char* video = (char*)0xb8000;  // Adresse mémoire de la vidéo texte
    while (*msg) {
        *video++ = *msg++;
        *video++ = 0x07;  // Attribut (gris sur noir)
    }

    while (1);  // Boucle infinie
}
