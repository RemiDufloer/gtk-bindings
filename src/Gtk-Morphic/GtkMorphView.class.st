"
I'm a widget to display morphs. 
"
Class {
	#name : #GtkMorphView,
	#superclass : #GtkMorphicDrawingArea,
	#instVars : [
		'activeSurface',
		'drawQueued',
		'damageRecorder',
		'activeHand',
		'alarms',
		'layeredMorphs',
		'kmDispatcher',
		'updating',
		'morphicRoot'
	],
	#category : #'Gtk-Morphic'
}

{ #category : #private }
GtkMorphView class >> drawingAreaNew [

	^ self ffiCall: #(GtkMorphView *gtk_drawing_area_new ())
]

{ #category : #examples }
GtkMorphView class >> example1 [

	GtkEngine ensureRunning.
	
	GtkWindow new 
		resize: 500@500;
		add: (GtkPaned newHorizontal
			pack1: (GtkLabel newLabel: 'Label');
			pack2: (GtkMorphView newMorph: (Morph new
				addMorphBack: 'Test' asStringMorph;
				yourself));
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example2 [
	| morph positionMorph |
	"show mouse events"
	GtkEngine ensureRunning.

	morph := Morph new.
	morph addMorphBack: (positionMorph := StringMorph contents: '[Position]').
	morph 
		on: #mouseMove 
		send: #value:
		to: [ :event | positionMorph contents: event position asString ].

	GtkWindow new
		title: 'Mouse-move test';
		resize: 500@500;
		add: (GtkBox newVertical 
			packStart: (GtkMorphView newMorph: morph);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example3 [
	| morph |

	GtkEngine ensureRunning.

	morph  := self 
		newGridOf: 10 
		with: [ | cell |
			(cell := Morph new)
				color: Color blue;
				on: #mouseEnter send: #value: to: [ :event | cell color: Color red ];
				on: #mouseLeave send: #value: to: [ :event | cell color: Color blue ] ].

	GtkWindow new
		title: 'Example 3';
		resize: 500@500;
		add: (GtkBox newVertical
			packStart: (GtkMorphView newMorph: morph);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example4 [
	| morph1 morph2 |

	GtkEngine ensureRunning.

	morph1 := self 
		newGridOf: 10
		with: [ | cell |
			(cell := Morph new)
				color: Color blue;
				on: #mouseEnter send: #value: to: [ :event | cell color: Color red ];
				on: #mouseLeave send: #value: to: [ :event | cell color: Color blue ] ].
	morph2 := self 
		newGridOf: 10 
		with: [ | cell | 
			(cell := Morph new)
				color: Color green;
				on: #mouseEnter send: #value: to: [ :event | cell color: Color red ];
				on: #mouseLeave send: #value: to: [ :event | cell color: Color green ] ].

	GtkWindow new
		title: 'Example 4';
		resize: 500@500;
		add: (GtkPaned newVertical 
			pack1: (GtkMorphView newMorph: morph1);
			pack2: (GtkMorphView newMorph: morph2);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example5 [
	| morph inform |

	GtkEngine ensureRunning.

	inform := GtkInfoArea new.

	morph  := self 
		newGridOf: 5 
		with: [ :pos | 
			PluggableButtonMorph new
				label: pos asString;
				actionBlock: [ inform addInfo: pos asString ];
				yourself ].

	GtkWindow new
		title: 'Example 5';
		resize: 500@500;
		add: (GtkBox newVertical
			packStart: inform expand: false fill: false padding: 0;
			packStart: (GtkMorphView newMorph: morph);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example6 [
	| morph inform |

	GtkEngine ensureRunning.

	inform := GtkInfoArea new.

	morph  := self 
		newGridOf: 5 
		with: [ :pos | 
			PluggableButtonMorph new
				label: pos asString;
				actionBlock: [ inform addInfo: pos asString ];
				helpText: 'Button at ', pos asString;
				yourself ].

	GtkWindow new
		title: 'PlugabbleButtonMorph Event Example';
		resize: 500@500;
		add: (GtkBox newVertical
			packStart: inform expand: false fill: false padding: 0;
			packStart: (GtkMorphView newMorph: morph);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example7 [
	| morph inform |

	GtkEngine ensureRunning.

	inform := GtkInfoArea new.

	morph  := self 
		newGridOf: 5 
		with: [ :pos | 
			SimpleButtonMorph new
				label: pos asString;
				color: Color random;
				target: [ inform addInfo: pos asString ];
				actionSelector: #value;
				helpText: 'Button at ', pos asString;
				yourself ].

	GtkWindow new
		title: 'SimpleButtonMorph Event Example';
		resize: 500@500;
		add: (GtkBox newVertical
			packStart: inform expand: false fill: false padding: 0;
			packStart: (GtkMorphView newMorph: morph);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> example8 [
	| morph1 morph2 inform |

	GtkEngine ensureRunning.

	inform := GtkInfoArea new.

	morph1  := self 
		newGridOf: 5 
		with: [ :pos | 
			SimpleButtonMorph new
				label: pos asString;
				color: Color random;
				target: [ inform addInfo: pos asString ];
				actionSelector: #value;
				helpText: 'Button at ', pos asString;
				yourself ].

	morph2  := self 
		newGridOf: 5 
		with: [ :pos | 
			SimpleButtonMorph new
				label: pos asString;
				color: Color random;
				target: [ inform addInfo: pos asString ];
				actionSelector: #value;
				helpText: 'Button at ', pos asString;
				yourself ].

	GtkWindow new
		title: 'SimpleButtonMorph Event Example';
		resize: 500@500;
		add: (GtkBox newVertical
			packStart: inform expand: false fill: false padding: 0;
			packStart: (GtkPaned newVertical
				position: 250;
				add: (GtkMorphView newMorph: morph1);
				add: (GtkMorphView newMorph: morph2);
				yourself);
			yourself);
		showAll
]

{ #category : #examples }
GtkMorphView class >> newGridOf: aNumber with: aBlock [
	| gridMorph |

	(gridMorph := Morph new)
		color: Color transparent;
		layoutPolicy: TableLayout new;
		borderWidth: 10;
		cellInset: 10;
		listDirection: #topToBottom;
		vResizing: #spaceFill; 
		hResizing: #spaceFill.

	1 to: aNumber do: [ :y | | row |
		row := (Morph new color: Color transparent).
		row
			layoutPolicy: TableLayout new;
			listDirection: #leftToRight;
			cellInset: 10;
			vResizing: #spaceFill; 
			hResizing: #spaceFill.
		1 to: aNumber do: [ :x | |  cell |
			cell := aBlock cull: x@y.
			cell
				vResizing: #spaceFill; 
				hResizing: #spaceFill. 
			row addMorphBack: cell ].
		gridMorph addMorphBack: row ].
	
	^ gridMorph
]

{ #category : #'instance creation' }
GtkMorphView class >> newMorph: aMorph [

	^ self new 
		morph: aMorph;
		yourself

]

{ #category : #'world simulation' }
GtkMorphView >> activateCursor: aCursor withMask: aForm [ 
	
	self flag: #TODO.
]

{ #category : #private }
GtkMorphView >> activeSurface [
	
	^ activeSurface
]

{ #category : #private }
GtkMorphView >> activeSurface: aSurface [

	activeSurface := aSurface
]

{ #category : #'world simulation' }
GtkMorphView >> addAlarm: aSelector withArguments: argArray for: aTarget at: scheduledTime [
	"Add a new alarm with the given set of parameters"
	| newAlarm |

	newAlarm := GtkMorphicAlarm 
		scheduledAt: scheduledTime
		receiver: aTarget
		selector: aSelector
		arguments: argArray.

	alarms ifNil: [ alarms := Set new ].
	alarms add: newAlarm.
	
	newAlarm schedule
]

{ #category : #configuration }
GtkMorphView >> beMorphNotResizable [
	
	morphicRoot beMorphNotResizable
]

{ #category : #configuration }
GtkMorphView >> beMorphResizable [
	
	morphicRoot beMorphResizable
]

{ #category : #private }
GtkMorphView >> canDraw [

	^ self morph notNil
]

{ #category : #'world simulation' }
GtkMorphView >> colorForInsets [
	^ Color transparent  
]

{ #category : #initialization }
GtkMorphView >> createEventHandler [

	^ GtkMorphicEventHandler for: morphicRoot 
]

{ #category : #'world simulation' }
GtkMorphView >> currentCursor [
	
	self flag: #TODO. "cursor handling"
	^ Cursor normal
]

{ #category : #'world simulation' }
GtkMorphView >> currentCursor: aCursor [

	self flag: #TODO.
]

{ #category : #private }
GtkMorphView >> currentExtent [

	^ self morph extent
]

{ #category : #'world simulation' }
GtkMorphView >> defer: aBlock [

	GRunLoop forceDefer: aBlock
]

{ #category : #drawing }
GtkMorphView >> draw: cr [

	(drawing or: [ self canDraw not ]) ifTrue: [ ^ true ].

	drawing := true.	
	[
		self needUpdate 
			ifTrue: [ self updateSurface ].
		self setSourceSurfaceTo: cr surface: activeSurface getHandle.
		self paint: cr ]
	ensure: [ 
		drawing := false.
		drawQueued := false ].
	
	^ true
]

{ #category : #'private - events' }
GtkMorphView >> handleEvent: event [
	self morph ifNil: [ ^ false ].
	^ super handleEvent: event

	
]

{ #category : #initialization }
GtkMorphView >> initialize [ 

	super initialize.
	morphicRoot := MorphicRoot new.
	morphicRoot container: self.

	morphicRoot beMorphResizable.

	drawQueued := false.
	drawing := false.
	
	eventHandler := self createEventHandler.
	updating := true.
	
	self connectDestroy: [ morphicRoot destroy ]	.
]

{ #category : #'world simulation' }
GtkMorphView >> invalidRect: damageRect from: aMorph [

	self isUpdating 
		ifFalse: [ self sizeRequest: aMorph extent ].
	self invalidateRect: damageRect
]

{ #category : #accessing }
GtkMorphView >> invalidate [

	morphicRoot invalidate
]

{ #category : #'world simulation' }
GtkMorphView >> isCursorOwner [

	^ true
]

{ #category : #'private - testing' }
GtkMorphView >> isUpdating [

	^ updating
]

{ #category : #'world simulation' }
GtkMorphView >> kmDispatcher [

	^ kmDispatcher ifNil: [ kmDispatcher := KMDispatcher target: self ]
]

{ #category : #'world simulation' }
GtkMorphView >> layoutChanged [

]

{ #category : #accessing }
GtkMorphView >> morph [

	^ morphicRoot morph
]

{ #category : #accessing }
GtkMorphView >> morph: aMorph [
	
	morphicRoot morph: aMorph
]

{ #category : #testing }
GtkMorphView >> needUpdate [

	^ morphicRoot needUpdate
]

{ #category : #private }
GtkMorphView >> newSurfaceOfMorph: aMorph [
	| newSurface |

	newSurface := AthensCairoSurface extent: aMorph extent.
	newSurface drawDuring: [ :canvas |
		canvas pathTransform translateBy: aMorph position negated.
		aMorph fullDrawOnAthensCanvas: canvas ].
	^ newSurface
]

{ #category : #'world simulation' }
GtkMorphView >> owner [

	^ nil
]

{ #category : #'private - updating' }
GtkMorphView >> paintMorph: aMorph [

	^ morphicRoot paintMorph: aMorph.
	"| cr position morphSurface |
	'je veux dessiner' trace. aMorph traceCr.
	position := aMorph position.
	morphSurface := self newSurfaceOfMorph: aMorph.
	cr := self cairoCreate: self activeSurface getHandle.
	[
		self 
			setSourceSurfaceTo: cr 
			surface: morphSurface getHandle
			x: position x asFloat
			y: position y asFloat.
		self paint: cr ]
	ensure: [ 
		self cairoDestroy: cr ]"
]

{ #category : #'world simulation' }
GtkMorphView >> paneColorOrNil [
	
	
]

{ #category : #'world simulation' }
GtkMorphView >> removeAlarm: aSelector for: aTarget [
	
	alarms ifNil: [ ^ self ].
	alarms
		detect: [ :each | 
			each receiver == aTarget 
			and: [ each selector == aSelector ] ]
		ifFound: [ :anAlarm | 
			anAlarm cancel.
			alarms remove: anAlarm ]
]

{ #category : #'world simulation' }
GtkMorphView >> removedMorph: aMorph [
]

{ #category : #private }
GtkMorphView >> resizeIfEnabledTo: extent [

	morphicRoot isMorphResizable ifFalse: [ ^ self ].
	self morph ifNil: [ ^ self ].
	self updatingWhile: [ morphicRoot extent: extent ]
]

{ #category : #'world simulation' }
GtkMorphView >> theme [

	^ Smalltalk ui theme
]

{ #category : #'private - updating' }
GtkMorphView >> updateSurface [
	| newSurface |
	
	newSurface := AthensCairoSurface extent: self morph extent.
	newSurface drawDuring: [ :canvas |
		canvas pathTransform translateBy: self morph position negated.
		self morph fullDrawOnAthensCanvas: canvas ].
	self activeSurface: newSurface
]

{ #category : #'private - updating' }
GtkMorphView >> updatingWhile: aBlock [
	| oldUpdating |

	oldUpdating := updating.
	updating := true.
	aBlock ensure: [ 
		updating := oldUpdating ]
]

{ #category : #'world simulation' }
GtkMorphView >> viewBox [

	^ self boundingBox
]

{ #category : #'world simulation' }
GtkMorphView >> withAllOwnersDo: aBlock [
	
	aBlock value: self
]

{ #category : #accessing }
GtkMorphView >> world [ 

^ morphicRoot world
]

{ #category : #hands }
GtkMorphView >> worldRenderer [
	
	^ morphicRoot worldRenderer 
]

{ #category : #'as yet unclassified' }
GtkMorphView >> worldState [
	
	^ morphicRoot worldState 
]
