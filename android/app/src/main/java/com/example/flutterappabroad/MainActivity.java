package com.example.flutterappabroad;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.display.DisplayManager;
import android.hardware.display.VirtualDisplay;
import android.media.MediaRecorder;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.Settings;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.SparseIntArray;
import android.view.Surface;
import android.view.View;
import android.widget.Toast;
import android.widget.ToggleButton;
import com.google.android.material.snackbar.Snackbar;


import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;


import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "flutter.native/helper";

    private static final int REQUEST_CODE = 1000;
    private int mScreenDensity;
    private MediaProjectionManager mProjectionManager;
    private static final int DISPLAY_WIDTH = 720;
    private static final int DISPLAY_HEIGHT = 1280;
    private MediaProjection mMediaProjection;
    private VirtualDisplay mVirtualDisplay;
    private MediaProjectionCallback mMediaProjectionCallback;
    private static final SparseIntArray ORIENTATIONS = new SparseIntArray();
    private static final int REQUEST_PERMISSIONS = 10;
    MediaRecorder mMediaRecorder;
    private static final String LOG_TAG = "AudioRecordTest";
    private static final String TAG = "Recorder";
    private boolean isRecording = false;
    static  String welcomeMessage = "Please enable Microphone and Storage permissions";



    static {
        ORIENTATIONS.append(Surface.ROTATION_0, 90);
        ORIENTATIONS.append(Surface.ROTATION_90, 0);
        ORIENTATIONS.append(Surface.ROTATION_180, 270);
        ORIENTATIONS.append(Surface.ROTATION_270, 180);
    }


  @Override
  protected  void  onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if(call.method.equals("helloFromNativeCode")) {
                  String greetings = helloFromNativeCode();
                  result.success(greetings);
                } else if (call.method.equals("screenRecordingFromNative")) {
                    String recordingStatus = screenRecordingFromNative();
                    result.success(recordingStatus);
                }
              }
            }
    );
  }

  private String helloFromNativeCode() {

      return "Hello from Native Android Code";
  }

  private  String screenRecordingFromNative() {


//      mToggleButton = (ToggleButton) findViewById(R.id.toggle);
//      mToggleButton.setOnClickListener(new View.OnClickListener() {
//          @Override
//          public void onClick(View v) {
//
//          }
//      });
      if (isRecording) {
          isRecording = false;
          mMediaRecorder.stop();
          mMediaRecorder.reset();
          Log.v(TAG, "Stopping Recording");
          stopScreenSharing();
          Log.v(TAG,"enter");


          return "Stopped";
      } else {
          recordingPrepare();
          shareScreen();
          isRecording = true;
          return  "Recording...";
      }

  }

  public void recordingPrepare() {
      DisplayMetrics metrics = new DisplayMetrics();
      getWindowManager().getDefaultDisplay().getMetrics(metrics);
      mScreenDensity = metrics.densityDpi;

      mMediaRecorder = new MediaRecorder();

      mProjectionManager = (MediaProjectionManager) getSystemService
              (Context.MEDIA_PROJECTION_SERVICE);

      if (ContextCompat.checkSelfPermission(MainActivity.this,
              Manifest.permission.WRITE_EXTERNAL_STORAGE) + ContextCompat
              .checkSelfPermission(MainActivity.this,
                      Manifest.permission.RECORD_AUDIO)
              != PackageManager.PERMISSION_GRANTED) {
          if (ActivityCompat.shouldShowRequestPermissionRationale
                  (MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE) ||
                  ActivityCompat.shouldShowRequestPermissionRationale
                          (MainActivity.this, Manifest.permission.RECORD_AUDIO)) {
              Log.v(TAG,"Permission Granted");
              Snackbar.make(findViewById(android.R.id.content), welcomeMessage,
                      Snackbar.LENGTH_LONG).setAction("ENABLE",
                      new View.OnClickListener() {
                          @Override
                          public void onClick(View v) {
                              ActivityCompat.requestPermissions(MainActivity.this,
                                      new String[]{Manifest.permission
                                              .WRITE_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO},
                                      REQUEST_PERMISSIONS);
                          }
                      }).show();
          } else {
              Log.v(TAG,"Permission Granted2");

              ActivityCompat.requestPermissions(MainActivity.this,
                      new String[]{Manifest.permission
                              .WRITE_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO},
                      REQUEST_PERMISSIONS);
          }
      } else {
          Log.v(TAG,"Permission Not Granted");

          //onToggleScreenShare(v);
      }
      initRecorder();
  }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode != REQUEST_CODE) {
            Log.e(TAG, "Unknown request code: " + requestCode);
            return;
        }
        if (resultCode != RESULT_OK) {
            Toast.makeText(this,
                    "Screen Cast Permission Denied", Toast.LENGTH_SHORT).show();
            return;
        }
        mMediaProjectionCallback = new MediaProjectionCallback();
        mMediaProjection = mProjectionManager.getMediaProjection(resultCode, data);
        mMediaProjection.registerCallback(mMediaProjectionCallback, null);
        mVirtualDisplay = createVirtualDisplay();
        Log.v(TAG,"Started M");
        mMediaRecorder.start();
    }

//    public void onToggleScreenShare(View view) {
//        if (((ToggleButton) view).isChecked()) {
//            initRecorder();
//            shareScreen();
//        } else {
//            mMediaRecorder.stop();
//            mMediaRecorder.reset();
//            Log.v(TAG, "Stopping Recording");
//            stopScreenSharing();
//        }
//    }

    private void shareScreen() {
        if (mMediaProjection == null) {
            startActivityForResult(mProjectionManager.createScreenCaptureIntent(), REQUEST_CODE);
            return;
        }
        mVirtualDisplay = createVirtualDisplay();
        Log.v(TAG,"Started D");
            mMediaRecorder.start();
    }

    private VirtualDisplay createVirtualDisplay() {
        return mMediaProjection.createVirtualDisplay("MainActivity",
                DISPLAY_WIDTH, DISPLAY_HEIGHT, mScreenDensity,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                mMediaRecorder.getSurface(), null /*Callbacks*/, null
                /*Handler*/);
    }

    private void initRecorder() {
        try {
            java.util.Date date= new java.util.Date();
            String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(date.getTime());
            mMediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
           // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                mMediaRecorder.setVideoSource(MediaRecorder.VideoSource.SURFACE);
           // }
            mMediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
                Log.v(TAG, "outputFile");

//                mMediaRecorder.setOutputFile(Environment
//                        .getExternalStoragePublicDirectory(Environment
//                                .DIRECTORY_PICTURES) + "/video" + timeStamp + ".mp4");
                Log.v(TAG,Environment
                        .getExternalStoragePublicDirectory(Environment
                                .DIRECTORY_DOWNLOADS)  + "/video" + timeStamp + ".mp4");


            }
            File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(
                    Environment.DIRECTORY_PICTURES), "MyCameraApp");
            if (! mediaStorageDir.exists()){
                if (! mediaStorageDir.mkdirs()){
                    Log.d("MyCameraApp", "failed to create directory");
                }
            }
            File mediaFile;
            mediaFile = new File(mediaStorageDir.getPath() + File.separator +
                    "VID_"+ timeStamp + ".mp4");
            mMediaRecorder.setOutputFile(mediaStorageDir.getPath() + File.separator + "VID_"+ timeStamp + ".mp4");

            mMediaRecorder.setVideoSize(DISPLAY_WIDTH, DISPLAY_HEIGHT);
            mMediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264);
            mMediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
            mMediaRecorder.setVideoEncodingBitRate(512 * 1000);
            mMediaRecorder.setVideoFrameRate(30);
            int rotation = getWindowManager().getDefaultDisplay().getRotation();
            int orientation = ORIENTATIONS.get(rotation + 90);
            mMediaRecorder.setOrientationHint(orientation);
            mMediaRecorder.prepare();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private class MediaProjectionCallback extends
            MediaProjection.Callback {
        @Override
        public void onStop() {
            //if (mToggleButton.isChecked()) {
                mMediaRecorder.stop();
                mMediaRecorder.reset();
                Log.v(TAG, "Recording Stopped");
           // }
            mMediaProjection = null;
            stopScreenSharing();
        }
    }

    private void stopScreenSharing() {
        if (mVirtualDisplay == null) {
            return;
        }
        mVirtualDisplay.release();
        //mMediaRecorder.release(); //If used: mMediaRecorder object cannot
        // be reused again
        destroyMediaProjection();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        destroyMediaProjection();
    }

    private void destroyMediaProjection() {
        if (mMediaProjection != null) {
            mMediaProjection.unregisterCallback(mMediaProjectionCallback);
            mMediaProjection.stop();
            mMediaProjection = null;
        }
        Log.i(TAG, "MediaProjection Stopped");
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String permissions[],
                                           @NonNull int[] grantResults) {
        switch (requestCode) {
            case REQUEST_PERMISSIONS: {
                if ((grantResults.length > 0) && (grantResults[0] +
                        grantResults[1]) == PackageManager.PERMISSION_GRANTED) {
                } else {
                    Snackbar.make(findViewById(android.R.id.content), welcomeMessage,
                            Snackbar.LENGTH_INDEFINITE).setAction("ENABLE",
                            new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    Intent intent = new Intent();
                                    intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                                    intent.addCategory(Intent.CATEGORY_DEFAULT);
                                    intent.setData(Uri.parse("package:" + getPackageName()));
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                                    intent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
                                    startActivity(intent);
                                }
                            }).show();
                }
                return;
            }
        }
    }


}
