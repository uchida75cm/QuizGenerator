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
package jp.nium.text {
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import jp.nium.collections.IIdGroup;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.impls.IExDisplayObject;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.display.ExMovieClip;
	import jp.nium.impls.ITextField;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">ExTextField クラスは、TextField クラスの基本機能を拡張した jp.nium パッケージで使用される基本的な表示オブジェクトクラスです。</span>
	 * <span lang="en">ExTextField class is a basic display object class used at jp.nium package which extends the basic function of TextField class.</span>
	 * 
	 * @see jp.nium.display#getInstanceById()
	 * @see jp.nium.display#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // ExTextField インスタンスを作成する
	 * var txt:ExTextField = new ExTextField();
	 * </listing>
	 */
	public class ExTextField extends TextField implements ITextField, IExDisplayObject, IIdGroup {
		
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
		 * @see #getInstanceById()
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
		 * <span lang="ja">新しい ExTextField インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExTextField object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function ExTextField( initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 親クラスを初期化する
			super();
			
			// コレクションに登録する
			ExMovieClip.nium_internal::$collection.addInstance( this );
			
			// 初期化する
			initObject ||= {};
			
			// テキストを取得する
			var text:String = initObject.text || "";
			delete initObject.text;
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
			
			// text が存在すれば最後に設定する
			super.text = text;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">newText パラメータで指定されたストリングを、テキストフィールドのキャレット位置に付加します。</span>
		 * <span lang="en">Add the string specified as newText parameter to the caret position of the TextField.</span>
		 * 
		 * @param newText
		 * <span lang="ja">既存のテキストに追加するストリングです。</span>
		 * <span lang="en">The string to add to the existence text.</span>
		 */
		public function appendTextAtCaretIndex( newText:String ):void {
			var s:String = text.slice( 0, caretIndex );
			var e:String = text.slice( caretIndex, super.text.length );
			
			super.text = s + newText + e;
			super.setSelection( s.length + 1, e.length + 1 );
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
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, _classNameObj.toString(), id ? "id" : null );
		}
	}
}
