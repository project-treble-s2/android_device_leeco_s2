/*
 *  LeEco Extras Settings Module
 *  Made by @andr68rus 2017
 *  Updated and cleaned up by Gabr0 2018
 *  Moderniced it by kihope
 *
 *  Modified by Akash98Sky for s2
 *
 */

package com.lineageos.settings.lepref;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.Preference;
import android.os.Build;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.preference.PreferenceScreen;
import android.preference.SwitchPreference;
import android.provider.Settings;
import android.view.Menu;
import android.view.MenuItem;

import android.os.SystemProperties;
import java.io.*;

public class LePrefSettings extends PreferenceActivity implements OnPreferenceChangeListener {
    private static final boolean DEBUG = false;
    private static final String TAG = "LePref";
    private static final String ENABLE_QC_KEY = "qc_setting";
    private static final String ENABLE_VSYNC_KEY = "vsync_setting";
    private static final String ENABLE_IB_RING = "ibr_setting";
    private static final String ENABLE_IAF_KEY = "iaf_setting";
    
    private static final String VSYNC_SYSTEM_PROPERTY = "debug.cpurend.vsync";
    private static final String BACKPRESSURE_SYSTEM_PROPERTY = "debug.sf.disable_backpressure";
    private static final String QC_SYSTEM_PROPERTY = "persist.sys.le_fast_chrg_enable";
    private static final String IB_RING_SYSTEM_PROPERTY = "persist.bluetooth.disableinbandringing";
    private static final String IAF_SYSTEM_PROPERTY = "persist.camera.HAL3.enabled";

    private SwitchPreference mEnableQC;
    private SwitchPreference mEnableVSync;
    private SwitchPreference mIbRing;
    private SwitchPreference mEnableIAF;

    private Context mContext;
    private SharedPreferences mPreferences;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.le_settings);
        mContext = getApplicationContext();

        mEnableQC = (SwitchPreference) findPreference(ENABLE_QC_KEY);
        mEnableQC.setChecked(SystemProperties.getBoolean(QC_SYSTEM_PROPERTY, true));
        mEnableQC.setOnPreferenceChangeListener(this);
        
        mEnableVSync = (SwitchPreference) findPreference(ENABLE_VSYNC_KEY);
        mEnableVSync.setChecked(SystemProperties.getBoolean(VSYNC_SYSTEM_PROPERTY, false));
        mEnableVSync.setOnPreferenceChangeListener(this);

        mIbRing = (SwitchPreference) findPreference(ENABLE_IB_RING);
        mIbRing.setChecked(!SystemProperties.getBoolean(IB_RING_SYSTEM_PROPERTY, false));
        mIbRing.setOnPreferenceChangeListener(this);
        
        mEnableIAF = (SwitchPreference) findPreference(ENABLE_IAF_KEY);
        mEnableIAF.setChecked(!SystemProperties.getBoolean(IAF_SYSTEM_PROPERTY, true));
        mEnableIAF.setOnPreferenceChangeListener(this);
    }
      
    // Control Quick Charge
    private void setEnableQC(boolean value) {
      if(value) {
        SystemProperties.set(QC_SYSTEM_PROPERTY, "1");
      } else {
        SystemProperties.set(QC_SYSTEM_PROPERTY, "0");
      }
    }
    
    // Control Vertical Sync
    private void setEnableVSync(boolean value) {
      if(value) {
        SystemProperties.set(VSYNC_SYSTEM_PROPERTY, "true");
        SystemProperties.set(BACKPRESSURE_SYSTEM_PROPERTY, "0");
      } else {
        SystemProperties.set(VSYNC_SYSTEM_PROPERTY, "false");
        SystemProperties.set(BACKPRESSURE_SYSTEM_PROPERTY, "1");
      }
    }
    
    // Control In-Band Ringing
    private void setEnableIbRing(boolean value) {
      if(value) {
        SystemProperties.set(IB_RING_SYSTEM_PROPERTY, "0");
      } else {
        SystemProperties.set(IB_RING_SYSTEM_PROPERTY, "1");
      }
    }
    
    // Control In-App Focus Fix
    private void setEnableIAF(boolean value) {
      if(value) {
        SystemProperties.set(IAF_SYSTEM_PROPERTY, "0");
      } else {
        SystemProperties.set(IAF_SYSTEM_PROPERTY, "1");
      }
      SystemProperties.set("init.prop.toggle.iaf", "1");
    }
    
    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onStop() {
      super.onStop();
      SystemProperties.set("init.prop.toggle.iaf", "0");
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
            return true;
        }
        return false;
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        final String key = preference.getKey();
        boolean value;
        String strvalue;
        if (ENABLE_QC_KEY.equals(key)) {
          value = (Boolean) newValue;
          mEnableQC.setChecked(value);
          setEnableQC(value);
          return true;
		    }
        if (ENABLE_VSYNC_KEY.equals(key)) {
          value = (Boolean) newValue;
          mEnableVSync.setChecked(value);
          setEnableVSync(value);
          return true;
		    }
        if (ENABLE_IB_RING.equals(key)) {
          value = (Boolean) newValue;
          mIbRing.setChecked(value);
          setEnableIbRing(value);
          return true;
        }
        if (ENABLE_IAF_KEY.equals(key)) {
          value = (Boolean) newValue;
          mEnableIAF.setChecked(value);
          setEnableIAF(value);
          return true;
        }
        return false;
    }
}
