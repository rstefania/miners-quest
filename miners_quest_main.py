import clips
import pygame
import time

# ----------------------------
# Parametri generali
# ----------------------------
ROWS, COLS = 8, 8
CELL = 60
WIDTH, HEIGHT = COLS * CELL, ROWS * CELL
FPS = 1  # pas CLIPS pe secundă

NAMES = {
    1: "Nicio caramida",
    2: "Traseu printre caramizi",
    3: "Comoara blocata"
}

pygame.init()
pygame.display.set_caption("Miner's Quest - Menu")
screen = pygame.display.set_mode((WIDTH, HEIGHT))
font = pygame.font.SysFont(None, 36)

# ----------------------------
# Functii pentru meniu grafic
# ----------------------------
def desen_meniu():
    background = pygame.transform.scale(pygame.image.load("dirt.png"), (WIDTH, HEIGHT))
    screen.blit(background, (0, 0))

    title = font.render("Alege instanta:", True, (0, 0, 0))
    screen.blit(title, (WIDTH // 2 - title.get_width() // 2, 40))

    buttons = []
    button_width = 300
    button_height = 70
    spacing = 30
    start_y = 120

    brick_color = (183, 94, 58)  # culoare apropiata de brick.jpg

    for i, name in NAMES.items():
        rect = pygame.Rect(WIDTH // 2 - button_width // 2,
                           start_y + (i - 1)*(button_height + spacing),
                           button_width,
                           button_height)
        pygame.draw.rect(screen, brick_color, rect, border_radius=10)
        label = font.render(f"{i}: {name}", True, (255, 255, 255))
        screen.blit(label, (
            rect.x + (rect.width - label.get_width()) // 2,
            rect.y + (rect.height - label.get_height()) // 2
        ))
        buttons.append((rect, i))

    pygame.display.flip()
    return buttons

def asteapta_selectie():
    while True:
        buttons = desen_meniu()
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                exit()
            elif event.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                for rect, idx in buttons:
                    if rect.collidepoint(pos):
                        return idx

# ----------------------------
# Selectare instanta grafic
# ----------------------------
INSTANCE_ID = asteapta_selectie()

pygame.display.set_caption(f"Miner's Quest - {NAMES[INSTANCE_ID]}")

# ----------------------------
# Incarcare CLIPS
# ----------------------------
env = clips.Environment()
env.load("miners_quest.clp")
env.reset()

for f in list(env.facts()):
    if f.template.name == "instanta-selectata":
        f.retract()
env.assert_string(f"(instanta-selectata (id {INSTANCE_ID}))")
env.run(1)

# ----------------------------
# Incarcare imagini
# ----------------------------
brick_img    = pygame.transform.scale(pygame.image.load("brick.jpg"),    (CELL, CELL))
treasure_img = pygame.transform.scale(pygame.image.load("treasure.png"), (CELL, CELL))
miner_img    = pygame.transform.scale(pygame.image.load("miner.png"),    (CELL, CELL))
ground_img   = pygame.transform.scale(pygame.image.load("dirt.png"),     (CELL, CELL))

# ----------------------------
# Functie extragere pozitii
# ----------------------------
def extrage_pozitii():
    miner = None
    treasure = None
    bricks = []
    for f in env.facts():
        if f.template.name != "are-pozitia":
            continue
        ent = f["entitate"]
        row = int(f["linie"]) - 1
        col = int(f["coloana"]) - 1
        if ent == "miner":
            miner = (row, col)
        elif ent == "comoara":
            treasure = (row, col)
        elif ent == "caramida":
            bricks.append((row, col))
    return miner, treasure, bricks

# ----------------------------
# Afisare pozitie initiala
# ----------------------------
miner_pos, treasure_pos, bricks = extrage_pozitii()

for r in range(ROWS):
    for c in range(COLS):
        screen.blit(ground_img, (c * CELL, r * CELL))

for (r, c) in bricks:
    screen.blit(brick_img, (c * CELL, r * CELL))
if treasure_pos:
    screen.blit(treasure_img, (treasure_pos[1]*CELL, treasure_pos[0]*CELL))
if miner_pos:
    screen.blit(miner_img, (miner_pos[1]*CELL, miner_pos[0]*CELL))

pygame.display.flip()
time.sleep(1)  # afiseaza pozitia initiala 1 secunda

# ----------------------------
# Loop principal joc
# ----------------------------
clock = pygame.time.Clock()
running = True

while running:
    fired = env.run(1)

    miner_pos, treasure_pos, bricks = extrage_pozitii()

    if miner_pos == treasure_pos:
        l, c = treasure_pos
        print(f"\nFelicitari! Minerul a gasit comoara la ({l + 1}, {c + 1})\n")
        break
    if fired == 0:
        print("\nAVERTISMENT: Comoara este blocata si minerul nu poate ajunge la ea!\n")
        break

    for r in range(ROWS):
        for c in range(COLS):
            screen.blit(ground_img, (c * CELL, r * CELL))

    for (r, c) in bricks:
        screen.blit(brick_img, (c * CELL, r * CELL))
    if treasure_pos:
        screen.blit(treasure_img, (treasure_pos[1]*CELL, treasure_pos[0]*CELL))
    if miner_pos:
        screen.blit(miner_img, (miner_pos[1]*CELL, miner_pos[0]*CELL))

    pygame.display.flip()
    clock.tick(FPS)

    for ev in pygame.event.get():
        if ev.type == pygame.QUIT:
            running = False

pygame.quit()
