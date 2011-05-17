/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://progression.jp/
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package jp.progression.commands.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">RemoveChild クラスは、対象の表示リストから指定された名前の DisplayObject インスタンスを削除するコマンドクラスです。
	 * 削除するインスタンスが ICastObject インターフェイスを実装している場合には、CastEvent.CAST_REMOVED イベントが送出され、
	 * 対象のイベント処理の実行中に、addCommand() メソッド、及び insertCommand() メソッドによるコマンドの同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.commands.display.RemoveAllChildren
	 * @see jp.progression.commands.display.RemoveChild
	 * @see jp.progression.commands.display.RemoveChildAt
	 * 
	 * @example <listing version="3.0">
	 * // CastSprite インスタンスを作成する
	 * var container:CastSprite = new CastSprite();
	 * var child:CastSprite = new CastSprite();
	 * 
	 * // 親子関係を設定する
	 * container.addChild( child );
	 * 
	 * // 名前を設定する
	 * child.name = "mychild";
	 * 
	 * // RemoveChildByName インスタンスを作成する
	 * var com:RemoveChildByName = new RemoveChildByName( container, "mychild" );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class RemoveChildByName extends RemoveChild {
		
		/**
		 * @private
		 */
		override public function get child():* { return null; }
		override public function set child( value:* ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "child" ) ); }
		
		/**
		 * <span lang="ja">削除したい子 DisplayObject の名前を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get childName():String { return _childName; }
		public function set childName( value:String ):void { _childName = value; }
		private var _childName:String;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい RemoveChildByName インスタンスを作成します。</span>
		 * <span lang="en">Creates a new RemoveChildByName object.</span>
		 * 
		 * @param containerRefOrId
		 * <span lang="ja">指定された DisplayObject インスタンスを削除する対象の DisplayObjectContainer インスタンス、またはインスタンスを示す識別子です。</span>
		 * <span lang="en"></span>
		 * @param name
		 * <span lang="ja">削除したい子 DisplayObject の名前です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function RemoveChildByName( containerRefOrId:DisplayObjectContainer, childName:String, initObject:Object = null ) {
			// 引数を設定する
			_childName = childName;
			
			// 親クラスを初期化する
			super( containerRefOrId, null, initObject );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override internal function _getChildRef():DisplayObject {
			return _containerRef.getChildByName( _childName );
		}
		
		/**
		 * <span lang="ja">RemoveChildByName インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an RemoveChildByName subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい RemoveChildByName インスタンスです。</span>
		 * <span lang="en">A new RemoveChildByName object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new RemoveChildByName( super.container, _childName, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "container", "childName" );
		}
	}
}
