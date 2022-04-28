Extension { #name : #FT2FFILibrary }

{ #category : #'*Gtk-FreeType' }
FT2FFILibrary >> calloutAPIClass [ 

	^ TFCalloutAPI
]

{ #category : #'*Gtk-FreeType' }
FT2FFILibrary >> runner [

	^ TFSameThreadRunner uniqueInstance
]
