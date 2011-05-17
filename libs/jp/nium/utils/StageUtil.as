/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.utils {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">StageUtil クラスは、Stage 操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The StageUtil class is an utility class for stage operation.</span>
	 */
	public final class StageUtil {
		
		/**
		 * @private
		 */
		public function StageUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">SWF ファイル書き出し時にドキュメントとして設定されたクラスを返します。</span>
		 * <span lang="en">Returns the class that set as document when writing the SWF file.</span>
		 * 
		 * @param stage
		 * <span lang="ja">ドキュメントを保存している stage インスタンスです。</span>
		 * <span lang="en">The stage instance which save the document.</span>
		 * @return
		 * <span lang="ja">ドキュメントとして設定された表示オブジェクトです。</span>
		 * <span lang="en">The display object that set as document.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getDocument( stage:Stage ):Sprite {
			if ( !stage ) { return null; }
			
			for ( var i:int = 0, l:int = stage.numChildren; i < l; i++ ) {
				var child:Sprite = stage.getChildAt( i ) as Sprite;
				
				if ( !child ) { continue; }
				if ( child.root == child ) { return child; }
			}
			
			return null;
		}
		
		/**
		 * <span lang="ja">ステージの左マージンを取得します。</span>
		 * <span lang="en">Get the left margin of the stage.</span>
		 * 
		 * @param stage
		 * <span lang="ja">マージンを取得したい stage インスタンスです。</span>
		 * <span lang="en">The stage instance to get the margin.</span>
		 * @return
		 * <span lang="ja">左マージンです。</span>
		 * <span lang="en">The left margin.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getMarginLeft( stage:Stage ):Number {
			// ドキュメントクラスを取得する
			var root:Sprite = getDocument( stage );
			
			try {
				var rootWidth:Number = root.loaderInfo.width;
				var stageWidth:Number = stage.stageWidth;
			}
			catch ( err:Error ) { return 0; }
			
			switch ( stage.scaleMode ) {
				case StageScaleMode.NO_SCALE	: {
					switch ( stage.align ) {
						case StageAlign.BOTTOM_LEFT		:
						case StageAlign.LEFT			:
						case StageAlign.TOP_LEFT		: { return 0; }
						case StageAlign.BOTTOM_RIGHT	:
						case StageAlign.RIGHT			:
						case StageAlign.TOP_RIGHT		: { return ( stageWidth - rootWidth ); }
						default							: { return ( stageWidth - rootWidth ) / 2; }
					}
				}
				case StageScaleMode.EXACT_FIT	:
				case StageScaleMode.NO_BORDER	:
				case StageScaleMode.SHOW_ALL	: { return 0; }
			}
			
			return 0;
		}
		
		/**
		 * <span lang="ja">ステージの上マージンを取得します。</span>
		 * <span lang="en">Get the top margin of the stage.</span>
		 * 
		 * @param stage
		 * <span lang="ja">マージンを取得したい stage インスタンスです。</span>
		 * <span lang="en">The stage instance to get the margin.</span>
		 * @return
		 * <span lang="ja">上マージンです。</span>
		 * <span lang="en">The top margin.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getMarginTop( stage:Stage ):Number {
			// ドキュメントクラスを取得する
			var root:Sprite = getDocument( stage );
			
			try {
				var rootHeight:Number = root.loaderInfo.height;
				var stageHeight:Number = stage.stageHeight;
			}
			catch ( err:Error ) { return -1; }
			
			switch ( stage.scaleMode ) {
				case StageScaleMode.NO_SCALE	: {
					switch ( stage.align ) {
						case StageAlign.TOP				:
						case StageAlign.TOP_LEFT		:
						case StageAlign.TOP_RIGHT		: { return 0; }
						case StageAlign.BOTTOM			:
						case StageAlign.BOTTOM_LEFT		:
						case StageAlign.BOTTOM_RIGHT	: { return ( stageHeight - rootHeight ); }
						default							: { return ( stageHeight - rootHeight ) / 2; }
					}
				}
				case StageScaleMode.EXACT_FIT	:
				case StageScaleMode.NO_BORDER	:
				case StageScaleMode.SHOW_ALL	: { return 0; }
			}
			
			return 0;
		}
	}
}
