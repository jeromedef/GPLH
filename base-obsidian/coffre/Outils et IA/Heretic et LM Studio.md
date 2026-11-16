---
type: travail
theme: Outils et IA
statut: terminé (voie simple)
debut: 2026-11-12
derniere_maj: 2026-11-13
sources: [claude-code-cloud:session_01DnZbuXG9hpH1rhtidHLEZ8]
tags: [ia-locale, lm-studio, heretic, intel-arc]
---
# Heretic et LM Studio

## En bref
L'objectif était d'essayer une IA dont les refus ont été retirés par Heretic (`p-e-w/heretic`, licence AGPL-3.0), par la voie simple : LM Studio et un modèle déjà traité. C'est fait et le test est réussi. LM Studio sert aussi de moteur local pour [[Hermes Agent]].

## Contexte
- Le [[ZenBook Duo]] n'a **pas de carte Nvidia** : `nvidia-smi` est introuvable. Il a une puce **Intel Arc 140T** intégrée.
- La voie « passer soi-même un modèle dans Heretic » a été écartée : elle est pensée pour une carte Nvidia.

## Décisions et choix
- 12/11 — **Voie simple :** LM Studio avec un modèle Heretic publié par l'auteur de l'outil.
- 13/11 — **Modèle :** Qwen3 4B plutôt que Gemma 3 12B, car la mémoire était utilisée à 76 % et la puce graphique est intégrée.

## Réalisations et fichiers produits
- **LM Studio 0.4.28+2**, installé par `winget install -e --id ElementLabs.LMStudio --scope user`. L'installateur provient de `installers.lmstudio.ai`, et son empreinte a été vérifiée.
- **Moteur :** « Vulkan llama.cpp (Windows) » v2.73.0. Page Hardware : « 1 GPU detected with Vulkan », Intel Arc 140T, **17,88 Go** de VRAM partagée, RAM 31,37 Go.
- **Modèle téléchargé :** `bartowski/p-e-w_Qwen3-4B-Instruct-2507-heretic-GGUF`, fichier **Q4_K_S** de 2,38 Go. LM Studio l'a présélectionné à la place du Q4_K_M visé ; l'écart de qualité est négligeable.
- **Tests :**
  - présentation en français : OK ;
  - monologue d'un méchant pour un roman policier : rédigé sans refus. La qualité d'écriture reste limitée pour un modèle de 4 milliards de paramètres.

## Actions en attente
- [ ] Vérifier où est stocké le modèle : `Get-ChildItem "$HOME\.lmstudio\models" -Recurse -Filter *.gguf`.
- [ ] Facultatif : essayer **Gemma 3 12B** (`mradermacher/gemma-3-12b-it-heretic-GGUF`, Q4_K_M de 7,4 Go), meilleur en français mais plus lent. Il faut libérer environ 9 Go de mémoire.
- [ ] Facultatif : comparer avec le modèle d'origine sur la même question.

## Points de vigilance
- L'usage reste encadré par la loi, et l'IA peut se tromper. Le modèle s'est d'ailleurs présenté à tort comme « à très grande échelle ».
- **Ne jamais brancher un modèle Heretic sur Hermes** ni sur un agent doté d'outils.

## Astuces LM Studio 0.4
- La page des moteurs est cachée : **Ctrl + Maj + R**. Le matériel s'affiche avec **Ctrl + Maj + H**.
- La ligne CUDA indique « Non Compatible » : c'est normal sans carte Nvidia.
- Pour discuter : onglet Chat, puis **Ctrl + L** pour charger un modèle. Utiliser **Eject** pour libérer la mémoire.

## Sources
- Claude Code (cloud) — session_01DnZbuXG9hpH1rhtidHLEZ8 — 12 et 13/11/2026.

## Liens
- [[Hermes Agent]] · [[ZenBook Duo]] · [[Sommaire]]
