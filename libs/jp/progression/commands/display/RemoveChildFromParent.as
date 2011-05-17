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
	import flash.display.DisplayObjectContainer;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">RemoveChildFromParent クラスは、対象が設置されている親の表示リストから DisplayObject インスタンスを削除するコマンドクラスです。
	 * 削除するインスタンスが ICastObject インターフェイスを実装している場合には、CastEvent.CAST_REMOVED イベントが送出され、
	 * 対象のイベント処理の実行中に、addCommand() メソッド、及び insertCommand() メソッドによるコマンドの同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.commands.display.RemoveAllChildren
	 * @see jp.progression.commands.display.RemoveChild
	 * @see jp.progression.commands.display.RemoveChildByName
	 * 
	 * @example <listing version="3.0">
	 * // CastSprite インスタンスを作成する
	 * var container:CastSprite = new CastSprite();
	 * var child:CastSprite = new CastSprite();
	 * 
	 * // 親子関係を設定する
	 * container.addChild( child );
	 * 
	 * // RemoveChildFromParent インスタンスを作成する
	 * var com:RemoveChildFromParent = new RemoveChildFromParent( child );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class RemoveChildFromParent extends RemoveChild {
		
		/**
		 * @private
		 */
		override public function get container():* { return null; }
		override public function set container( value:* ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "container" ) ); }
		
		
		
		
		
		/**
		 * <span lang="ja">新しい RemoveChildFromParent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new RemoveChildFromParent object.</span>
		 * 
		 * @param childRefOrId
		 * <span lang="ja">表示リストから削除したい DisplayObject インスタンス、またはインスタンスを示す識別子です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function RemoveChildFromParent( childRefOrId:*, initObject:Object = null ) {
			// 親クラスを初期化する
			super( null, childRefOrId, initObject );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override internal function _getParentRef():DisplayObjectContainer {
			return _getObjectRef( child ).parent;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
		}
		
		/**
		 * <span lang="ja">RemoveChildFromParent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an RemoveChildFromParent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい RemoveChildFromParent インスタンスです。</span>
		 * <span lang="en">A new RemoveChildFromParent object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new RemoveChildFromParent( super.child, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "child" );
		}
	}
}
