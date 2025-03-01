

Les liens utiles : 
- Doc de Godot Engine 4.x en français :  https://docs.godotengine.org/fr/4.x/

- Bibliothèques de  :
	*   composants, outils, scripts, projets, templates :   https://godotassetlibrary.com/
	*   objets 3D :    https://free3d.com/   (parfois trop complexes et trop lourds), charger des blends ou des fbx
	*   objets plus ou moins simples selon thèmes :   https://zsky2000.itch.io/
	*   HDRIs (faire des Environment), textures, models:   https://polyhaven.com/all   (bien pour les textures de surface)
	*   Modèle 3D de personnages et animations : [Mixamo](https://www.mixamo.com/) : 


Tuto et composants :
	* https://www.youtube.com/watch?v=e1zJS31tr88&t=6s
	* starters kit (FPS, city builder) :   https://kenney.nl  (+textures basiques) pour des ressources 2D, 3D, audio, niveaux démo et outils.
	* GDQuest ([site](https://www.gdquest.com/) [chaîne Youtube](https://www.youtube.com/c/gdquest)


[Discord officiel](https://discord.com/invite/4JBkykG) - [Discord FR officiel](https://discord.com/invite/NQVd34V)

Plugin intéressants :
	* Simple TODO, en alternative à un kanban externe
	* Inventory Editor

Lancement manuel avec paramètres :
"c:\Program Files\Godot\Godot_v4.1.3-stable_win64.exe" root.tscn -- SERVER


Enchainement de scenes - Best practice :
----------------------------------------
* Il s'agit surtout d'éviter une boucle de chargement entre les scenes qui provoque un erreur de chargement du projet (invalide) ou un dysfonctionnement avec signalement d'une erreur
* Ne pas preloader les scenes des niveaux, mais sur choix du niveau coder :
	var level : PackedScene = load("res://level1.tscn")
	get_tree().change_scene_to_packed(level)
* Dans les niveaux, on peut éventuellement preloader le root pour y revenir plus rapidement


Set a Panorama Sky into Godot.
------------------------------
Open Godot and create a new project (or edit the one you are currently working on)

1) Add a WorldEnvironment node.
2) Into the Inspector, create a New Environment.
3) Select Edit
4) Go to Background → Mode, then select Sky
5) Into Sky, select : New PanoramaSky
6). Select Edit
7) Drag and drop the *.exr file previously created (we have of course moved this file into the work space of the project) to the field noted as "null"
Save the resource as well as the scene Done !
8) you can easily modify the contrast and brightness parameters : Go back into the resource edition panel → Adjustement→ Activate, and modify the needed parameters, the changes will be displayed in real-time into the viewport. Note: For a detailed list of the available options see Environment and Post-Processing into the Godot Documentation. Don’t forget to save both resource and scene after each modification.


Définir un niveau 3D rapidement :
---------------------------------

Utiliser des CSG
Pour la boîte de la pièce principale (CSGbox), cocher "Flip Faces" et "Use Collision"


Terminer un jeu :
-----------------
get_tree().quit()

ou sur action ESCAPE (qui ne soit pas déjà traitée avant) :

func _unhandled_input(event: InputEvent):
	if (event.is_action_released("ui_cancel")):
		get_tree().quit()


Définir des setters :
---------------------
1) Coder le setter :
	var xxx = 100:
		set(value):
			# vérifier, modifie, etc...
			xxx = value
2) Coder le getter :
	var xxx: int:
		get:
			# precalcul, ...
			return value
   Attention quand même aux effets de surprise puisque ça veut dire qu'une variable peut changer spontanément


Définir un signal :
-------------------
1) code dans l'émetteur
	signal  sigtosend
2) accepter de recevoir le signal (dans _ready)
	objemetteur.sigtosend.connect($objreceveur.fonction.bind() )

Réfléchir à une bonne architecture (où sont les datas, comment on transmet les infos vers l'UI)



Associer un audio :
-------------------

1) créer un AudioStreamPlayer au niveau du node qui va émettre le son
2) faire un dragndrop du fichier son dans la propriété Stream
3) Coder là où il faut jouer le son
	if not $TheStreamPlayer.is_playing():   # pour éviter l'accumulation des sons
		$TheStreamPlayer.play()
peut être arrété avec .stop()


Importer un personnage (à partir d'un fbx de mixamo) :
------------------------------------------------------
1) Créer un CharacterBody3D
2) Y ajouter un Marker3D (au cas où)
3) Copier le fichier Fbx du Character dans le système de fichier (arborescence "3D Imports")
4) Déplacer le Fbx sous le noeud du Marker3D, renommer le noeud
5) Déclarer le noeud comme Local (ce qui permet d'accéder  au skelette, aux Mesh et aux animations par défaut


Importer des animations (à partir d'un fbx de mixamo) :
-------------------------------------------------------
1) Copier le fichier Fbx du Character dans le système de fichier (arborescence "3D Imports")
2) Sélectionner le Fbx et basculer sur l'onglet "Importer" (à côté de "Scène")
3) choisir "Importer comme" "Animation Library"
4) choisir "Discard all Texture" dans la section glTF
5) Peut-être pas nécessaire d'ouvrir les apramètres avancés ("Avancement....")
6) cliquer sur "Réimporter" (ce qui force un restart)
7) aller sur l'animationPlayer du Caracter et passer en mode Animation
8) Faire "Animation" -> "Gérer les animations"
9) "charger une librairie animation" et choisir le Fbx, "Ouvrir", "OK"
10) Dans l'Animation, choisir l'animation XXX/mixamo_com et la dupliquer vers l'"échelle" globale
11) En repassant dans "Animation" -> "Gérer les animations", faire le ménage dans ce qui vient d'être chargé
12) renommer éventuellement l'animation, modifier pour mettre en boucle par exemple
13) on peut alors coder :
	AnimationPlayer.play("nom-animation")


Faire une animation d'un personnage chargé via un glb :
-------------------------------------------------------
1) Ajouter un noeud AnimationPlayer dans le noeud du Personnage
2) !!!???  Associer une animation avec le fichier glb !!!???
3) Visualiser les animations et les détails dans l'onglet "Animation" tout en bas
4) Préinitialiser l'animation
	@onready var animation = $Marker3D/Personnage/AnimationPlayer
5) Jouer les animations selon ce qui est proposé par l'animation 
		animation.play("Run")
6) ou
		animation.play("Idle")


Créer une animation à partir d'un objet Area3D :
------------------------------------------------
1) Ajouter un noeud AnimationPlayer dans le noeud de l'objet (Area3D)
2) Passer en mode 3D pour visualiser l'objet
3) Visualiser les animations et les détails dans l'onglet "Animation" tout en bas
4) zone Animation, faire Animation->Nouveau, et nommer l'animation et régler la durée de la piste
5) sélectionner l'objet à animer et le positionner dans la position initiale
6) pour le type de mouvement (rotation, position, ...) cliquer sur la clé
7) accepter la création de la piste
8) position le marqueur de l'étape-clé sur la frise chronologique
9) déplacer l'objet, cliquer sur la clé, positionner l'étape clé sur la frise chronologique
10) itérer
11) Jouer les animations selon ce qui est proposé par l'animation 
		$AnimationPlayer.play("nom du mouvement")


Faire afficher un label 3D à la bonne taille et toujours face caméra :
----------------------------------------------------------------------
1) Créer le Label3D
2) Mettre la propriété BillBoard à Enabled (axe Z face caméra)
3) Régler le Pixel Size à 0.01 ou 0.02 (à tuner)
4) Régler le Font Size à 32 (à tuner, les 2 sizes sont liées)


Comprendre les collisions
-------------------------
Le layer indique la(es) couche(s) dans la(es)quelle on est.
Le mask indique que l'on veut être "conscient" ou "averti" des objets qui sont dans les layers en question
Ainsi les objets Character avec un mask N collisineront et glisseront sur les Static ou Rigids ou Characters de la layer N
Et les Area2D et Area3D avec un mask N déclencheront des signaux sur les collisions (body_enter) avec les Statics, Rigids ou Chracter de la layer N


Détecter des ennemis à proximité (dégats subis en fonction de la durée de contact) :
-------------------------------------------------
x) Définir une Area3D au niveau du joueur
x) Associer une shape (Capsule, Cylindre,...) pour la zone de blessure
x) Pour l'ennemi dans l'onglet Noeud, choisir Groupe et ajouter un groupe nommé "ennemi"
x) Coder dans _physics_process() du joueur  ( ou _process ?)
	var ennemis_proches = $Area3D.get_overlapping_bodies()
	for ennemi in ennemis_proches:
		if ennemi.is_in_group("ennemi"):
			vie -= BLESSURE * delta
			#get_tree().get_root().get_node("UI").get_node("Vie").text = vie
			$Marker3D/PtsVie.text = "%02d" % vie

x) autre possibilité pour éviter le is_in_group("") :
	x.x) positionner l'Area3D joueur dans le layer 2 (en fait ça importe peu)
	x.y) positionner l'ennemi dans le layer 3 (mais aussi dans le(s) layer(s) de décor pour qu'il puisse être bloqué)
	x.y) positionner le mask de l'Area3D joueur dans la zone 3, mais pas dans la 2


Prendre un objet quand on le touche (donc contact et collide ou slide) :
------------------------------------------------------------------------
x) pour le Player : layer 2 et mask 2
x) pour l'objet : layer 2 et mask -
x) coder pour le player :
	move_and_slide()
	
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		if body.is_in_group("objet") :
--> inconvénient de la méthode : le player détecte une slide_collision aussi avec le décor

!!!!! Note : si le player est dans le même layer que le terrain et le décor, il bute dessus simplement.


Faire une zone d'interaction avec un objet (près de l'objet mais sans contact) :
--------------------------------------------------------------------------------
x) Pour le player, dans un area3D avec collisionShape : mask 3
x) Pour l'objet, layer +3
x) associer les signaux de la zone Area3D du player :  body_entered, body_exited
x) pour conserver l'état de ce qui est proche, coder 
	func _on_area_3d_body_entered(body):
	if body.is_in_group("arbre"):
		#print ("près d'un arbre ")
		sapinsProches[body.get_rid()] = body
	elif body.is_in_group("feu"):
		print ("près du feu ")
	else:
		prints ("autre body :", body)
		
	func _on_area_3d_body_exited(body):
	if body.is_in_group("arbre"):
		#print("loin d'un' sapin")
		sapinsProches.erase(body.get_rid())
	etc...


Mettre un objet 3D dans du 2D :
-------------------------------
1) Dans un node2D, créer un subViewport contenant une camera3D, une source de lumière (OmniLight3D), l'objet à afficher
/!\ comme tout cela est un objet 3D, cela va se retrouver les uns sur les autres et va aussi apparaitre dans la scène principale (donc à cacher sous le floor. Pas joli)
2) code (exemple pour les Subview
		var subview : SubViewport
		subview = get_node("Subviews/SubViewportJewel%02d" % i)
		var textRect3D = TextureRect.new()
		textRect3D.set_texture(subview.get_texture())
		textRect3D.set_scale(Vector2(0.5,0.5))
--> Peut-être pas la solution idéale


Remplir automatiquement un vboxContainer avec des hboxContainer :
-----------------------------------------------------------------
avec des hbox contenant un objet et label

1) initialiser 
const vboxpath = "tout le chemin relatif/VBoxContainer"
@onready var vbox = get_node(vboxpath)

2) coder dans le _ready() :
	for i in range(1,N) :
		var hbox = HBoxContainer.new()
		hbox.set_name("Hbox%d" % i)
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.add_child(objet, par exemple un textureRect3D)
		var label = Label.new()
		label.set_name("Label") 
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.text = "%03d" % jewels[i-1]
		hbox.add_child(label)

		vbox.add_child(hbox)


Utilisation des ScrollContainer en 2D :
---------------------------------------
1) penser à décocher Clip Contents
!!! Globalement ça marche plutôt mal....


Prepositionner le focus :
-------------------------
1) coder
	$StartButton.grab_focus()


Changer l'aspect des Controls dynamiquement :
---------------------------------------------
1) Au niveau du composant ou à un niveau plus haut, pour le Theme, choisir un "Nouveau Theme"
2) Dans l'éditeur de Thème, "Ajouter" un nouveau type (de variation), ex: FocusedPanel
3) Pour le type créer, le choisir dans la liste "Type", pour commencer à l'éditer
4) Dans la barre outil, choisir à droite "Tournevis+Clé"
5) Dans le type de base, choisir le type de composant que l'on souhaite modifier (ex: PanelContainer)
6) Dans la barre d'outil, choisir ce que l'on veut modifier, notamment le StyleBox
7) Créer un "Nouveau StyleBoxXXXX" (Flat par exemple)
8) Dans le cas du StyleBox, sélectionner le StyleBox en question et faire les modifications dans l'Inspecteur
9) Revenir en arrière dans l'éditeur de Thème (bouton "<")
10) Enregistrer le theme (pour pouvoir le réutiliser)

11) Coder
	# Pour appliquer la variation :
	self.set_theme_type_variation("FocusedPanel") #<-- avec le nom de la variation
	# Pour supprimer la variation :
	self.set_theme_type_variation("")

Projeter les ombres sur le sol et les murs :
--------------------------------------------
1) Pour la source de lumière (Light3D), cocher "Shadow/Enabled"


Projeter une ombre sur une surface transparente (pour voir le sol de l'environnement) :
---------------------------------------------------------------------------------------
1) Pour la source de lumière (Light3D), cocher "Shadow/Enabled"
2) Pour le Mesh de la surface, choisir un "Plane Mesh" et le dimensionner suffisamment
3) Pour le Material, choisir un "StandardMaterial3D",
4)    y mettre "Blend Mode" à Substract
5)    y mettre en Albedo, une Color claire et non transparente (222,222,222,250)
6)    y mettre SURTOUT "Shadows/shadow to opacity" à Activé


Mettre le jeu en pause :
------------------------
1) positionner le Process Mode des UI ou des éléments non pausables à "Always"
2) Coder pour mettre en pause :
	get_tree().paused = false
3) Coder pour sortir de pause :
	TODO


Traitement des inputs (Best practices) :
----------------------------------------

* Ne mettre dans _process() ou _physics_process() que ce qui est directement lié au passage du temps
* Mettre dans _input() ce qui est lié à des actions ponctuelles
* Mettre dans _unhandled_input() toutes les actions exceptionnelles, non liées au Gameplay (ex: pause, quit)


Identifier un clic (ou autre événement souris) en 2D
----------------------------------------------------
* définir (ou utiliser) un Area2D (ou le PhysicalBody2D)
* dans l'Area2D, cocher Pickable
* dans l'Area2D, mettre au moins une layer (la 16 par exemple)
* dans les signaux de l'objet racine (ou l'Area2D ?!?), connecter le signal input_event avec la fonction _on_input_event
* coder :
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton :
		if event.pressed == true :
			if event.button_index == MOUSE_BUTTON_LEFT :
				etc...

ATTENTION, si un Control (Panel, etc...) recouvre la zone de clic potentiel, les clics seront interceptés.
Pour éviter cela, mettre dans le Control en question :
	Mouse.Filter = Pass   ou   Ignore


Identifier une zone de clic en 3D:
----------------------------------
* déterminer ce qui va pouvoir déterminer le space (par exemple le StaticBody3D du sol, mais ça peut être n'importe quoi...)
		var space_state = $StaticBody3D.get_world_3d().direct_space_state
* récupérer l'objet camera pour la camera current
* dans _input(event), coder :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		
		var result = space_state.intersect_ray(query)
		if result != null:
			...
* on peut alors utiliser result.position pour déterminer la position du premier objet rencontré (voire aussi les autres attributs)
* pour ne rencontrer que des objets d'une couche donnée, positionner query.collision_mask  avec le bitmask adequat (1 pour seul la layer 1)

Faire tourner la camera autour d'un point fixe avec la souris (bouton de droite appuyé) :
-----------------------------------------------------------------------------------------
* initialiser camrot à 0.0 dans la scène globale où est la caméra "Center"
* coder dans _input() :
	if event is InputEventMouseMotion:
		if event.button_mask & (MOUSE_BUTTON_MASK_MIDDLE + MOUSE_BUTTON_MASK_RIGHT):  ## pour le bouton de droite ou du milieu
			camrot += event.relative.x * 0.005
			get_node("Center").set_rotation(Vector3(0, camrot, 0))
			print("Camera3D Rotation: ", camrot)


Définir une zone de parcours :
------------------------------
1) Créer un NavigationRegion3D
2) Y définir un "Nouveau NavigationMesh"
3) Dans le noeud NavigationRegion3D, définir un MeshInstance (plutôt de type Plane de taille suffisante, mais on pourrait définir un Mesh compliqué pour forcer une zone de parcours (voire, via code, rattacher le mesh à la zone de terrain)
4) dans le _ready principal,  call_deferred("custom_setup")
5) coder le custom_setup() :
	await get_tree().physics_frame
	$NavigationRegion3D.bake_navigation_mesh(false)
6) déclencher les "ennemis" à déplacer :
	$Ennemi.actor_setup() en lui passant des instructions de parcours (ex: une liste d'étapes)



Déplacer un ennemi dans la zone de parcours :
---------------------------------------------

1) Ajouter un noeud NavigationAgent3D à l'ennemi
2) positionner "Path Height Offset à 0.5 ,  car bizarrement, le NavMesh se positionne à 0,5m au dessus de 0
3) coder la cible
	set_movement_target(Vector3)

4) coder le déplacement de l'ennemi dans _physics_process(delta) :
	if navigation_agent.is_navigation_finished():
		set_movement_target(next Vector3target)
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	if is_on_floor() :
		velocity = global_position.direction_to(next_path_position) * movement_speed * delta
		look_at(next_path_position,Vector3.UP)
	
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

### Trouver un tuto qui gère mieux la vitesse de chute (en mémorisant la dernière vitesse)


Mettre des obstacles dans une zone de parcours :
------------------------------------------------
1) Pour les nodes de type obstacle, ajouter un noeud NavigationObstacle3D, et cocher avoidance_enabled
2) Régler un radius pour inclure l'objet obstacle et positionner la zone autour de l'objet, sinon il faudra définir un tableau de vertex
3) Mettre les obstacles dans la NavigationRegion3D, manuellement ou via code
4) dans le _ready principal,  call_deferred("custom_setup")
5) coder le custom_setup() :
	await get_tree().physics_frame
	$NavigationRegion3D.bake_navigation_mesh(false)
6) déclencher l'ennemi
	$Ennemi.actor_setup() en lui passant des instructions de parcours (ex: une liste d'étapes)
7) coder le déplacement de l'ennemi (cf. ci-dessus)


Détecter un contact qui fait changer de direction dans le plan horisontal :
---------------------------------------------------------------------------

1) concerne uniquement un RigidBody3D
2) Coder
	func _integrate_forces(state):
	   for i in range(state.get_contact_count()):
		var impulse = state.get_contact_impulse(i)
		if impulse.x != 0 or impulse.z != 0:
			print ("contact delete")
			#self.queue_free() # par exemple


Remplir un élément avec une texture :
-------------------------------------
Ca peut être un TextureRect (Control) ou ...

1) Coder
	var imgpng = ResourceLoader.load("res://Ressources/image.png")	
	$MsgTexture.set_texture(imgpng)



Forcer les contrôles à s'adapter au passage en plein écran :
------------------------------------------------------------

1) Définir la fonction qui va propager le changement de taille de fenêtre :
	func resized():
	var vp : Viewport = get_viewport()
	$PanelContainer.size = vp.size
	$Menu/PanelContainer.size = vp.size

2) Mettre dans le _ready(), la détection des changement de taille, pour forcer la propagation :
	get_viewport().size_changed.connect(resized.bind())
	resized()

3) Eventuellement forcer le démarrage en Full Screen
	Paramètre du Projet
	->Affichage / Fenêtre
		->Mode = Fullscreen

Mettre une subview qui suit un personnage :
-------------------------------------------
1) Au niveau du terrain ? , créer les noeuds :
	SubViewport
		Personnage  (noeud complexe défini par ailleurs)
			Camera3D
2) Positionner correctement la camera3D (et ne surtout pas attacher la camera au sein de la définition de Personnage) :
Ainsi la camera va suivre le Personnage qui a sa propre dynamique (et contrôles)

3) Dans un Controle, faire afficher un TextureRect qui reprend le contenu du subviewport
	var textRect3D = TextureRect.new()
	textRect3D.set_texture(subviewport.get_texture())


Lancer une autre instance de GODOT :
------------------------------------
1) Coder (avec le même exe et les mêmes arguments + d'autres):
	var args = OS.get_cmdline_args()
	args.append("1autre-arg")
	var pid = OS.create_instance(args)
	if pid == -1 :
		# erreur

Créer un serveur pour du multi-player :
---------------------------------------
1) Coder :
	var peer = ENetMultiplayerPeer.new()
	var error : Error = peer.create_server(MULTIPLAYERPORT, MAX_CLIENTS)
	if (error == Error.OK):
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(newcnxmultiplayer.bind())
		multiplayer.peer_disconnected.connect(lostcnxmultiplayer.bind())
2) Coder les 2 func qui vont être averties des connexions et déconnexions des clients


Envoi d'un message de Broadcast UDP (recherche de serveur par exemple) :
-------------------------------------
1) Création du port UDP, coder :
	var broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
2) Envoi d'un message de broadcast sur le sous-réseau, contenant notamment un port, un nom d'appli, un pseudo :
	const BROADCASTPORT = 4343
	broadcaster.set_dest_address("255.255.255.255", BROADCASTPORT)
	var pos = 0
	var packet : PackedByteArray = PackedByteArray()
	packet.resize(80) # FIXME : optimiser la taille du packet
	packet.encode_u16(pos,RESPONSEPORT)
	pos += 2
	pos += packet.encode_var(pos,"GAME NAME")
	pos += packet.encode_var(pos,clientPseudo)
	broadcaster.put_packet(packet)

Ecoute et lecture d'un message UDP venant du broadcaster :
----------------------------------------------------------
1) Créer un Timer qui va venir écouter régulièrement (5 secondes par exemple) :
2) Création du port UDP d'écoute, coder :
	const BROADCASTPORT = 4343
	udplistener = PacketPeerUDP.new() 
	udplistener.bind(BROADCASTPORT)
	
3) Coder la fonction de timeout :
	var packet : PackedByteArray
	var pos = 0
	if udplistener.get_available_packet_count () > 0 :
		var packet : PackedByteArray
		packet = udplistener.get_packet()
		var fromip = udplistener.get_packet_ip()
		var onport = udplistener.get_packet_port()
		var port = packet.decode_u16(pos)
		pos += 2
		var msg = packet.decode_var(pos,true)
		pos += packet.decode_var_size(pos,true)
4) Il faut ensuite répondre au broadcaster
5) Il faut alors que le broadcaster écoute et lise la réponse
Ces échanges doivent permettre de se reconnaitre et de se mettre d'accord sur la suite (en particulier l'utlisation du MultiplayerAPI)


Utilisation de la MultiplayerAPI :
----------------------------------
1) Créer l'API côté serveur sur un port fixé par le serveur, peut se faire dès le _ready() du serveur
	var peer = ENetMultiplayerPeer.new()
	var error : Error = peer.create_server(MULTIPLAYERPORT, MAX_CLIENTS)
	if (error == Error.OK):
		multiplayer.multiplayer_peer = peer
		print ("server ready ",multiplayer.get_unique_id())
		multiplayer.peer_connected.connect(newcnxmultiplayer.bind())
		multiplayer.peer_disconnected.connect(lostcnxmultiplayer.bind())
2) Coder les fonctions qui vont traiter qu'un client s'est connecté ou s'est déconnecté

3) Créer l'API côté serveur sur un port fixé par le serveur, dès que le serveur a communiqué son MULTIPLAYERPORT
	var peer = ENetMultiplayerPeer.new()
	var error : Error = peer.create_client(ipserver, multiplayerport)
	if error == Error.OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(client_connected_to_server.bind())
		multiplayer.connection_failed.connect(client_connection_failed.bind())
		multiplayer.server_disconnected.connect(client_server_disconnected.bind())
4) Coder les fonctions qui vont traiter la gestion de la connexion effective au serveur et la déconnexion


Utilisation des TileMapLayers et TileSets (2D)
----------------------------------------------
1) Créer un node TileMapLayer, avec
	* Cell Quadrant à 16 ou 32 ou 64 (selon la taille des Tiles que l'on va importer dans le TileSet)
2) Dans le TileMapLayer, définir un "Nouveau TileSet" avec :
	* TileShape = Square (mais il faudrait essayer les autres un jour, en spécifiant aussi le Tile Layout)
	* TileSize égal au Cell Quadrant du TileMap (c'est plus logique)
3) dans le TileSet, ajouter
	* une Physics Layer avec un "nouvel Element" incluant 1 comme Collision Layer et Collision Mask (c'est en général du dur) et éventuellement un "Nouveau Physics Material"
	* un "Terrain Set" pour … (en mode "Corners and Sides" par défaut) et un "Terrain"
		définir une couleur de Terrain qui tranchera avec celle des Tiles
	* un "Custom Data Layer" pour pouvoir spécifier des valeurs spécifiques à certains Tiles
4) Refaire pour chaque Layer (depuis la 4.3)
5) dans le zone d'édition (en bas au centre), choisir "TileSet",
	puis faire glisser dans la zone "Tuiles" les fichiers (PNG) représentant les groupes de Tiles (qui doivent être de la taille définie ) aux étapes 1 et 2.
	à chaque fois, accepter (Oui) de créer les tuiles dans l'Atlas. Cela exclura les tiles vides (100% transparentes)
	A priori, dans la partie "Configuration", la "taille de région de texture" doit être cohérent avec le Cell Quadrant
6) dans la zone d'édition pour le TileSet,
	choisir "Peindre", avec la "Paint Properties" "Terrains"pour le TileSet ,
	choisir le Terrain Set et le Terrain souhaité
	et sélectionner les Tiles à inclure dans le Terrain
	/!\ un Tile ne peut appartenir qu'un un seul Terrain
	enfin sélectionner les bords et les coins qui seront contigus dans le terrain
7) dans la zone d'édition pour le TileSet, choisir "Sélectionner" et pour chaque Tile spécifique de chaque Atlas :
	modifier Miscellanous/Probabilité pour moins voir le Tile
	définir un polygone de collision dans Physics pour empêcher notamment le passage des Characters
	mettre à jour la valeur des "Données Personnalisées" définies via le "Custom Data Layers" à l'étape 3
8) dans la zone d'édition pour le TileMap, on peut alors
	* utiliser l'onglet  "Tuiles" pour positionner des Tiles une par une
	* utiliser l'onglet  "Terrain" pour remplir aléatoirement la TileMap à l'écran (case, ligne, rectangles,...)

	
