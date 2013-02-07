// =================================================================================================
//
//	CadetEngine Framework
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

// Inspectable Priority range 100-149

package cadet2D.components.skins
{	
	import cadet.events.InvalidationEvent;
	
	import cadet2D.components.textures.TextureAtlasComponent;
	import cadet2D.components.textures.TextureComponent;
	import cadet2D.events.SkinEvent;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ImageSkin extends AbstractSkin2D
	{
		private static const TEXTURE	:String = "texture";
		
		private var _texture			:TextureComponent;
/*		private var _fillXOffset		:Number = 0;
		private var _fillYOffset		:Number = 0;*/
		
		private var _image					:Image;
		
		private var _textureAtlas			:TextureAtlasComponent;
		private var _texturesPrefix			:String;
		
		// DEPRECATED
		//private var _fillBitmap			:BitmapData;
		private var _textureDirty			:Boolean;
		
		public function ImageSkin()
		{
			name = "ImageSkin";
			
//			image = new Image(NullBitmapTexture.instance);
//			_displayObject = image;
		}		
/*		
		[Serializable][Inspectable]
		public function set fillXOffset( value:Number ):void
		{
			_fillXOffset = value;
			invalidate( ASSET );
		}
		public function get fillXOffset():Number { return _fillXOffset; }
		
		[Serializable][Inspectable]
		public function set fillYOffset( value:Number ):void
		{
			_fillYOffset = value;
			invalidate( ASSET );
		}
		public function get fillYOffset():Number { return _fillYOffset; }
		
		//TODO: This needs to be deprecated in favour of "fillTexture"
		[Serializable( type="resource" )][Inspectable(editor="ResourceItemEditor")]
		public function set fillBitmap( value:BitmapData ):void
		{
			_fillBitmap = value;
			invalidate( ASSET );
		}
		public function get fillBitmap():BitmapData { return _fillBitmap; }	
*/		
		
		[Serializable][Inspectable( editor="ComponentList", scope="scene", priority="100" )]
		public function set textureAtlas( value:TextureAtlasComponent ):void
		{
			if ( _textureAtlas ) {
				_textureAtlas.removeEventListener(InvalidationEvent.INVALIDATE, invalidateAtlasHandler);
			}
			_textureAtlas = value;
			if ( _textureAtlas ) {
				_textureAtlas.addEventListener(InvalidationEvent.INVALIDATE, invalidateAtlasHandler);
			}
			// textureAtlas & texture are mutually exclusive values
			if (value)	_texture = null;
			invalidate( TEXTURE );
		}
		public function get textureAtlas():TextureAtlasComponent
		{
			return _textureAtlas;
		}
		
		[Serializable][Inspectable( priority="101" )]
		public function set texturesPrefix( value:String ):void
		{
			_texturesPrefix = value;
			invalidate( TEXTURE );
		}
		public function get texturesPrefix():String
		{
			return _texturesPrefix;
		}
		
		[Serializable][Inspectable( editor="ComponentList", scope="scene", priority="102" )]
		public function set texture( value:TextureComponent ):void
		{
			_texture = value;
			// textureAtlas & texture are mutually exclusive values
			if (value)	_textureAtlas = null;
			invalidate( TEXTURE );
		}
		public function get texture():TextureComponent { return _texture; }	
		
		
		override public function validateNow():void
		{
			if ( _textureDirty ) {
				invalidate(TEXTURE);
			}
			
			if ( isInvalid(TEXTURE) )
			{
				validateTexture();
			}
			
			super.validateNow();
		}
		
		override protected function validateDisplay():void
		{
			_displayObject.width = _width;
			_displayObject.height = _height;
		}
		
		protected function validateTexture():void
		{
			// Remove existing asset first
			if ( displayObject is DisplayObjectContainer ) {
				var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObject);
			}
			if ( _image && displayObjectContainer && displayObjectContainer.contains(_image) ) {
				displayObjectContainer.removeChild(_image);
			}
			
			var textures:Vector.<Texture>;
			
			if (_texture) {
				if (_texture.texture) {
					textures = new Vector.<Texture>();
					textures.push(_texture.texture);	
				} else {
					_textureDirty = true;
					return;
				}
			} else if ((_textureAtlas && !_textureAtlas.atlas) || !_texturesPrefix ) {
				_textureDirty = true;
				return;
			} else if (textureAtlas) {
				textures = _textureAtlas.atlas.getTextures(_texturesPrefix);
			}
			
			// textureAtlas has been set to null, quit out after removing current textures
			if (!_textureAtlas && !_texture) {
				return;
			}
			
			if (!textures || textures.length == 0) return;
			
			_image = new Image(textures[0]);
			
			if (displayObjectContainer) {
				displayObjectContainer.addChild(_image);
				// set default width and height
				//if (!_width) 	
				_width = _image.width;
				//if (!_height) 	
				_height = _image.height;				
			}
			
			_textureDirty = false;
			
			// Useful when not using editor as validation is not immediate
			dispatchEvent(new SkinEvent(SkinEvent.TEXTURE_VALIDATED));
		}

		private function invalidateAtlasHandler( event:InvalidationEvent ):void
		{
			invalidate( TEXTURE );
		}
		
		override public function clone():IRenderable
		{
			var newSkin:ImageSkin = new ImageSkin();
			newSkin.rotation = _rotation;
			newSkin.scaleX = _scaleX;
			newSkin.scaleY = _scaleY;
			newSkin.texture = _texture;
			newSkin.textureAtlas = _textureAtlas;
			newSkin.texturesPrefix = _texturesPrefix;
			newSkin.touchable = _displayObject.touchable;
			newSkin.transform2D = _transform2D;
			newSkin.x = _x;
			newSkin.y = _y;
			newSkin.width = _width;
			newSkin.height = _height;
			return newSkin;
		}
	}
}









