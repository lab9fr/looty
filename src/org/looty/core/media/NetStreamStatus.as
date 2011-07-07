/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/03/2010 21:22
 * @version 0.1
 */

package org.looty.core.media
{

	public final class NetStreamStatus
	{
		/**
		 * Data is not being received quickly enough to fill the buffer. Data flow is interrupted until the buffer refills, at which time a NetStream.Buffer.Full message is sent and the stream begins playing again.
		 * Status
		 */		
		static public const BUFFER_EMPTY					:String			= "NetStream.Buffer.Empty";
		
		/**
		 * The buffer is full and the stream begins playing.
		 * Status
		 */		
		static public const BUFFER_FULL						:String			= "NetStream.Buffer.Full";
		
		/**
		 * Data has finished streaming, and the remaining buffer will be emptied.
		 * Status
		 */
		static public const BUFFER_FLUSH					:String			= "NetStream.Buffer.Flush";
		
		/**
		 * A recorded stream was deleted successfully.
		 */
		static public const CLEAR_SUCCESS					:String			= "NetStream.Clear.Success";
		
		/**
		 * A recorded stream failed to delete.
		 */
		static public const CLEAR_FAILED					:String			= "NetStream.Clear.Failed";
		
		/**
		 * 
		 */
		static public const DATA_START						:String			= "NetStream.Data.Start";
		
		/**
		 * An error has occurred for a reason other than those listed elsewhere in this table, such as the subscriber trying to use the seek command to move to a particular location in the recorded stream, but with invalid parameters.
		 * Error
		 * @param description :String
		 */
		static public const FAILED							:String			= "NetStream.Failed";
		
		/**
		 * Invalid arguments were passed to a NetStream method.
		 */
		static public const INVALID_ARG						:String			= "NetStream.InvalidArg";
		
		/**
		 * The subscriber has paused playback.
		 * Status
		 */
		static public const PAUSE_NOTIFY					:String			= "NetStream.Pause.Notify";
		
		/**
		 * Flash Player detects an invalid file structure and will not try to play this type of file. Supported by Flash Player 9 Update 3 and later.
		 * Error
		 */
		static public const PLAY_FILE_STRUCTURE_INVALID		:String			= "NetStream.Play.FileStructureInvalid";
		
		/**
		 * Flash Player does not detect any supported tracks (video, audio or data) and will not try to play the file. Supported by Flash Player 9 Update 3 and later.
		 * Error
		 */
		static public const PLAY_NO_SUPPORTED_TRACK_FOUND	:String			= "NetStream.Play.NoSupportedTrackFound";
		
		/**
		 * Playback has completed. (streaming, not progressive download)
		 * Status
		 * @method onPlayStatus
		 */
		static public const PLAY_COMPLETE					:String			= "NetStream.Play.Complete";
		
		/**
		 * An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access.
		 * Error
		 * @param description :String
		 */
		static public const PLAY_FAILED						:String			= "NetStream.Play.Failed";
		
		/**
		 * Data is playing behind the normal speed.
		 * Warning
		 */
		static public const PLAY_INSUFFICIENT_BW			:String			= "NetSream.Play.InsufficientBW";
		
		/**
		 * Publishing has begun; this message is sent to all subscribers.
		 * Status
		 */
		static public const PLAY_PUBLISH_NOTIFY				:String			= "NetStream.Play.PublishNotify";
		
		/**
		 * The playlist has reset (pending play commands have been flushed).
		 * Status
		 */
		static public const PLAY_RESET						:String			= "NetStream.Play.Reset";
		
		/**
		 * Playback has started.
		 * Status
		 */
		static public const PLAY_START						:String			= "NetStream.Play.Start";
		
		/**
		 * Playback has stopped.
		 * Status
		 */
		static public const PLAY_STOP						:String			= "NetStream.Play.Stop";
		
		/**
		 * The client tried to play a live or recorded stream that does not exist.
		 * Error
		 */
		static public const PLAY_STREAM_NOT_FOUND			:String			= "NetStream.Play.StreamNotFound";
		
		/**
		 * The subscriber is switching from one stream to another in a playlist.
		 * Status
		 * @method onPlayStatus
		 */
		static public const PLAY_SWITCH						:String			= "NetStream.Play.Switch";
		
		/**
		 * Publishing has stopped; this message is sent to all subscribers.
		 * Status
		 */
		static public const PLAY_UNPUBLISH_NOTIFY			:String			= "NetStream.Play.UnpublishNotify";
		
		/**
		 * 
		 * @method onPlayStatus
		 */
		static public const PLAY_TRANSITION_COMPLETE		:String 		= "NetStream.Play.TransitionComplete"; 
		
		/**
		 * The client tried to publish a stream that is already being published by someone else.
		 * Error
		 */
		static public const PUBLISH_BAD_NAME				:String			= "NetStream.Publish.BadName";
		
		/**
		 * The publisher of the stream has been idling for too long.
		 * Status
		 */
		static public const PUBLISH_IDLE					:String			= "NetStream.Publish.Idle";
		
		/**
		 * Publishing has started.
		 * Status
		 */
		static public const PUBLISH_START					:String			= "NetStream.Publish.Start";
		
		/**
		 * An error has occurred in recording for a reason other than those listed elsewhere in this table; for example, the disk is full.
		 * Error
		 * @param description :String
		 */
		static public const RECORD_FAILED					:String			= "NetStream.Record.Failed";
		
		/**
		 * The client tried to record a stream that is still playing, or the client tried to record (overwrite) a stream that already exists on the server with read-only status.
		 * Error
		 */
		static public const RECORD_NO_ACCESS				:String			= "NetStream.Record.NoAccess";
		
		/**
		 * Recording has started.
		 * Status
		 */
		static public const RECORD_START					:String			= "NetStream.Record.Start";
		
		/**
		 * Recording has stopped.
		 * Status
		 */
		static public const RECORD_STOP						:String			= "NetStream.Record.Stop";
		
		/**
		 * 
		 */
		static public const SEEK_INVALID_TIME				:String			= "NetStream.Seek.InvalidTime";
		
		/**
		 * The subscriber tried to use the seek command to move to a particular location in the recorded stream, but failed.
		 * Error
		 */
		static public const SEEK_FAILED						:String			= "NetStream.Seek.Failed";
		
		/**
		 * The subscriber has used the seek command to move to a particular location in the recorded stream.
		 * Status
		 */
		static public const SEEK_NOTIFY						:String			= "NetStream.Seek.Notify";
		
		/**
		 * The subscriber has resumed playback.
		 * Status
		 */
		static public const UNPAUSE_NOTIFY					:String			= "NetStream.Unpause.Notify";
		
		/**
		 * Publishing has stopped.
		 * Status
		 */
		static public const UNPUBLISH_SUCCESS				:String			= "NetStream.Unpublish.Success";
		
		
		public function NetStreamStatus() 
		{
			
		}
		
	}

}

