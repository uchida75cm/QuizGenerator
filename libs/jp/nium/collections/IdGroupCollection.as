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
package jp.nium.collections {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.events.CollectionEvent;
	
	/**
	 * <span lang="ja">コレクションに対して、インスタンスが追加された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.nium.core.events.CollectionEvent.COLLECTION_UPDATE
	 */
	[Event( name="collectionUpdate", type="jp.nium.core.events.CollectionEvent" )]
	
	/**
	 * <span lang="ja">IIdGroup インターフェイスを継承したインスタンスを管理するコレクションクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class IdGroupCollection extends EventDispatcher {
		
		/**
		 * <span lang="ja">子インスタンスが保存されている配列です。
		 * この配列を操作することで元の配列を変更することはできません。</span>
		 * <span lang="en"></span>
		 */
		public function get instances():Array {
			var list:Array = [];
			
			for ( var instance:* in _instances ) {
				list.push( instance );
			}
			
			return list;
		};
		private var _instances:Dictionary;
		
		/**
		 * <span lang="ja">子として登録されているインスタンス数を取得します。</span>
		 * <span lang="en">Returns the number of children of this Instance.</span>
		 */
		public function get numInstances():uint { return _numInstances; }
		private var _numInstances:uint = 0;
		
		/**
		 * インスタンスをキーとして保持している Dictionary インスタンスを取得します。
		 */
		private var _ids:Dictionary;
		
		/**
		 * インスタンスをキーとして保持している Dictionary インスタンスを取得します。
		 */
		private var _groups:Dictionary;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい IdGroupCollection インスタンスを作成します。</span>
		 * <span lang="en">Creates a new IdGroupCollection object.</span>
		 */
		public function IdGroupCollection() {
			// Dictionary を作成する
			_instances = new Dictionary( true );
			_ids = new Dictionary();
			_groups = new Dictionary();
		}
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスを登録します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param instance
		 * <span lang="ja">登録したいインスタンスです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">インスタンスに割り当てられたユニークな番号です。</span>
		 * <span lang="en"></span>
		 */
		public function addInstance( instance:IIdGroup ):uint {
			_instances[instance] = _numInstances;
			
			// イベントを送出する
			super.dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_UPDATE, false, false, instance ) );
			
			return _numInstances++;
		}
		
		/**
		 * <span lang="ja">登録されているインスタンスに対して id を割り当てます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param instance
		 * <span lang="en">id を割り当てたいインスタンスです。</span>
		 * <span lang="en"></span>
		 * @param id
		 * <span lang="ja">割り当てたい id を示すストリングです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">割り当てられた id を示すストリングです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #getInstanceById()
		 */
		public function registerId( instance:IIdGroup, id:String ):Boolean {
			// 対象が存在しなければ例外をスローする
			if ( !instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_009 ).toString( "instance" ) ); }
			
			// すでに登録されていたら終了する
			if ( getInstanceById( id ) ) { return false; }
			
			if ( id ) {
				_ids[instance] = true;
			}
			else {
				delete _ids[instance];
			}
			
			// イベントを送出する
			super.dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_UPDATE, false, false, instance ) );
			
			return true;
		}
		
		/**
		 * <span lang="ja">指定された id と同じ値が設定されている IIdGroup インスタンスを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param id
		 * <span lang="ja">条件となるストリングです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">条件と一致するインスタンスです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #registerId()
		 */
		public function getInstanceById( id:String ):IIdGroup {
			// 存在しなければ終了する
			if ( !id ) { return null;  }
			
			// 検索する
			for ( var instance:* in _ids ) {
				if ( instance.id == id ) { return instance; }
			}
			
			return null;
		}
		
		/**
		 * <span lang="ja">登録されているインスタンスに対して group を割り当てます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param instance
		 * <span lang="en">group を割り当てたいインスタンスです。</span>
		 * <span lang="en"></span>
		 * @param group
		 * <span lang="ja">割り当てたい group を示すストリングです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">割り当てられた group を示すストリングです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #getInstancesByGroup()
		 */
		public function registerGroup( instance:IIdGroup, group:String ):Boolean {
			// 対象が存在しなければ例外をスローする
			if ( !instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_009 ).toString( "instance" ) ); }
			
			// グループを作成する
			_groups[group] ||= new Dictionary( true );
			
			if ( group ) {
				_groups[group][instance] = true;
			}
			else {
				// 既存の値を取得する
				group = instance.group;
				
				// 削除する
				delete _groups[group][instance];
				
				// グループ内項目の存在を確認する
				for ( var exists:* in _groups[group] ) { break; }
				
				// 1 つも存在しなければグループを削除する
				if ( !exists ) {
					delete _groups[group];
				}
			}
			
			return true;
		}
		
		/**
		 * <span lang="ja">指定された group と同じ値を持つ IIdGroup インスタンスを含む配列を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param group
		 * <span lang="ja">条件となるストリングです。</span>
		 * <span lang="en"></span>
		 * @param sort
		 * <span lang="ja">結果の配列をソートして返すかどうかを指定します。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">条件と一致するインスタンスを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #registerGroup()
		 */
		public function getInstancesByGroup( group:String, sort:Boolean = false ):Array {
			var result:Array = [];
			
			// 存在しなければ終了する
			if ( !group ) { return result;  }
			
			// 検索する
			var groups:Dictionary = _groups[group];
			for ( var instance:* in groups ) {
				if ( instance.group == group ) {
					result.push( { instance:instance, num:_instances[instance] } );
				}
			}
			
			// 生成順にソートする
			result.sortOn( [ "num" ], Array.NUMERIC );
			
			// 配列を再構築する
			for ( var i:int = 0, l:int = result.length; i < l; i++ ) {
				result[i] = result[i].instance;
			}
			
			// 名前でソートを行うのであれば
			if ( sort ) {
				result.sortOn( [ "id", "name", "group" ] );
			}
			
			return result;
		}
	}
}
