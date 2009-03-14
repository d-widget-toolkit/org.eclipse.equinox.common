/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.core.runtime.SafeRunner;

import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.core.runtime.MultiStatus;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.CoreException;

import org.eclipse.core.internal.runtime.IRuntimeConstants;

import org.eclipse.core.runtime.ISafeRunnable;
import org.eclipse.core.runtime.Assert;

import java.lang.all;

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
        Assert.isNotNull(cast(Object)code);
        try {
            code.run();
        } catch (Exception e) {
            handleException(code, e);
// SWT not in D
//         } catch (LinkageError e) {
//             handleException(code, e);
        }
    }

    private static void handleException(ISafeRunnable code, Exception e) {
        if( null is cast(OperationCanceledException) e ){

            // try to obtain the correct plug-in id for the bundle providing the safe runnable
//          Activator activator = Activator.getDefault();
            String pluginId = null;
//          if (activator !is null)
//              pluginId = activator.getBundleId(code);
            if (pluginId is null)
                pluginId = IRuntimeConstants.PI_COMMON;

            String message = null;
//          String message = NLS.bind(CommonMessages.meta_pluginProblems, pluginId);
            IStatus status;
            if ( auto ce = cast(CoreException) e ) {
                status = new MultiStatus(pluginId, IRuntimeConstants.PLUGIN_ERROR, message, e);
                (cast(MultiStatus) status).merge( ce.getStatus());
            } else {
                status = new Status(IStatus.ERROR, pluginId, IRuntimeConstants.PLUGIN_ERROR, message, e);
            }
            // Make sure user sees the exception: if the log is empty, log the exceptions on stderr
            //if (!RuntimeLog.isEmpty())
            //    RuntimeLog.log(status);
            //else
            ExceptionPrintStackTrace(e);
        }

        code.handleException(e);
    }
}
