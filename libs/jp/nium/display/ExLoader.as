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
package jp.nium.display {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import jp.nium.collections.IIdGroup;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.impls.IExDisplayObject;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.impls.IDisplayObjectContainer;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">ExLoader クラスは、Loader クラスの基本機能を拡張した jp.nium パッケージで使用される基本的な表示オブジェクトクラスです。</span>
	 * <span lang="en">ExLoader class is a basic display object class used at jp.nium package which extends the basic function of Loader class.</span>
	 * 
	 * @see jp.nium.display#getInstanceById()
	 * @see jp.nium.display#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // ExLoader インスタンスを作成する
	 * var loader:ExLoader = new ExLoader();
	 * </listing>
	 */
	public class ExLoader extends Loader implements IDisplayObjectContainer, IExDisplayObject, IIdGroup {
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the IExDisplayObject.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">インスタンスの識別子を取得または設定します。</span>
		 * <span lang="en">Indicates the instance id of the IExDisplayObject.</span>
		 * 
		 * @see jp.nium.display#getInstanceById()
		 */
		public function get id():String { return _id; }
		public function set id( value:String ):void {
			// 既存の登録を取得する
			var instance:IIdGroup = ExMovieClip.nium_internal::$collection.getInstanceById( value );
			
			// すでに存在していれば例外をスローする
			if ( instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_022 ).toString( value ) ); }
			
			// 登録する
			_id = ExMovieClip.nium_internal::$collection.registerId( this, value ) ? value : null;
		}
		private var _id:String;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group of the IExDisplayObject.</span>
		 * 
		 * @see jp.nium.display#getInstancesByGroup()
		 */
		public function get group():String { return _group; }
		public function set group( value:String ):void { _group = ExMovieClip.nium_internal::$collection.registerGroup( this, value ) ? value : null;  }
		private var _group:String;
		
		/**
		 * @private
		 */
		public function get children():Array { return []; }
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ExLoader インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExLoader object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function ExLoader( initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 親クラスを初期化する
			super();
			
			// コレクションに登録する
			ExMovieClip.nium_internal::$collection.addInstance( this );
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスに対して、複数のプロパティを一括設定します。</span>
		 * <span lang="en">Setup the several instance properties.</span>
		 * 
		 * @param parameters
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en">The object that contains the property to setup.</span>
		 * @return
		 * <span lang="ja">自身の参照です。</span>
		 * <span lang="en"></span>
		 */
		public function setProperties( parameters:Object ):DisplayObject {
			ObjectUtil.setProperties( this, parameters );
			return this;
		}
		
		/**
		 * @private
		 */
		public function addChildAtAbove( child:DisplayObject, index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addChildAtAbove" ) );
		}
		
		/**
		 * @private
		 */
		public function removeAllChildren():void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeAllChildren" ) );
		}
		
		/**
		 * @private
		 */
		public function setChildIndexAbove( child:DisplayObject, index:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "setChildIndexAbove" ) );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, _classNameObj.toString(), _id ? "id" : null );
		}
	}
}
