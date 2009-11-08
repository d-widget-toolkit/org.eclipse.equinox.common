/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
// Port to the D programming language:
//     Frank Benoit <benoit@tionex.de>
module org.eclipse.core.runtimeSafeRunner;

import java.lang.all;

import org.eclipse.core.runtimeStatus; // packageimport
import org.eclipse.core.runtimeMultiStatus; // packageimport
import org.eclipse.core.runtimeAssert; // packageimport
import org.eclipse.core.runtimeISafeRunnable; // packageimport
import org.eclipse.core.runtimeOperationCanceledException; // packageimport
import org.eclipse.core.runtimeIStatus; // packageimport
import org.eclipse.core.runtimeCoreException; // packageimport

import org.eclipse.core.internal.runtime.Activator;
import org.eclipse.core.internal.runtime.CommonMessages;
import org.eclipse.core.internal.runtime.IRuntimeConstants;
import org.eclipse.core.internal.runtime.RuntimeLog;
import org.eclipse.osgi.util.NLS;

/**
 * Runs the given ISafeRunnable in a protected mode: exceptions
 * thrown in the runnable are logged and passed to the runnable's
 * exception handler.  Such exceptions are not rethrown by this method.
 * <p>
 * This class can be used without OSGi running.
 * </p>
 * @since org.eclipse.equinox.common 3.2
 */
public final class SafeRunner {

    /**
     * Runs the given runnable in a protected mode.   Exceptions
     * thrown in the runnable are logged and passed to the runnable's
     * exception handler.  Such exceptions are not rethrown by this method.
     *
     * @param code the runnable to run
     */
    public static void run(ISafeRunnable code) {
        Assert.isNotNull(code);
        try {
            code.run();
        } catch (Exception e) {
            handleException(code, e);
        } catch (LinkageError e) {
            handleException(code, e);
        }
    }

    private static void handleException(ISafeRunnable code, Throwable e) {
        if (!( null !is cast(OperationCanceledException)e )) {
            // try to obtain the correct plug-in id for the bundle providing the safe runnable 
            Activator activator = Activator.getDefault();
            String pluginId = null;
            if (activator !is null)
                pluginId = activator.getBundleId(code);
            if (pluginId is null)
                pluginId = IRuntimeConstants.PI_COMMON;
            String message = NLS.bind(CommonMessages.meta_pluginProblems, pluginId);
            IStatus status;
            if ( null !is cast(CoreException)e ) {
                status = new MultiStatus(pluginId, IRuntimeConstants.PLUGIN_ERROR, message, e);
                (cast(MultiStatus) status).merge((cast(CoreException) e).getStatus());
            } else {
                status = new Status(IStatus.ERROR, pluginId, IRuntimeConstants.PLUGIN_ERROR, message, e);
            }
            // Make sure user sees the exception: if the log is empty, log the exceptions on stderr 
            if (!RuntimeLog.isEmpty())
                RuntimeLog.log(status);
            else
                e.printStackTrace();
        }
        code.handleException(e);
    }
}
