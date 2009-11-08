/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Julian Chen - fix for bug #92572, jclRM
 *******************************************************************************/
// Port to the D programming language:
//     Frank Benoit <benoit@tionex.de>
module org.eclipse.core.internal.runtimeRuntimeLog;

import java.lang.all;

import org.eclipse.core.internal.runtimeIRuntimeConstants; // packageimport

import java.util.ArrayList;
import java.util.Iterator;

import org.eclipse.core.runtime.ILogListener;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.OperationCanceledException;

/**
 * NOT API!!!  This log infrastructure was split from the InternalPlatform.
 * 
 * @since org.eclipse.equinox.common 3.2
 */
// XXX this must be removed and replaced with something more reasonable
public final class RuntimeLog {

    private static ArrayList logListeners = new ArrayList(5);

    /**
     * Keep the messages until the first log listener is registered.
     * Once first log listeners is registred, it is going to receive
     * all status messages accumulated during the period when no log
     * listener was available.
     */
    private static ArrayList queuedMessages = new ArrayList(5);

    /**
     * See org.eclipse.core.runtime.Platform#addLogListener(ILogListener)
     */
    public static void addLogListener(ILogListener listener) {
        synchronized (logListeners) {
            bool firstListener = (logListeners.size() is 0);
            // replace if already exists (Set behaviour but we use an array
            // since we want to retain order)
            logListeners.remove(listener);
            logListeners.add(listener);
            if (firstListener) {
                for (Iterator i = queuedMessages.iterator(); i.hasNext();) {
                    try {
                        IStatus recordedMessage = cast(IStatus) i.next();
                        listener.logging(recordedMessage, IRuntimeConstants.PI_RUNTIME);
                    } catch (Exception e) {
                        handleException(e);
                    } catch (LinkageError e) {
                        handleException(e);
                    }
                }
                queuedMessages.clear();
            }
        }
    }

    /**
     * See org.eclipse.core.runtime.Platform#removeLogListener(ILogListener)
     */
    public static void removeLogListener(ILogListener listener) {
        synchronized (logListeners) {
            logListeners.remove(listener);
        }
    }

    /**
     * Checks if the given listener is present
     */
    public static bool contains(ILogListener listener) {
        synchronized (logListeners) {
            return logListeners.contains(listener);
        }
    }

    /**
     * Notifies all listeners of the platform log.
     */
    public static void log(final IStatus status) {
        // create array to avoid concurrent access
        ILogListener[] listeners;
        synchronized (logListeners) {
            listeners = (ILogListener[]) logListeners.toArray(new ILogListener[logListeners.size()]);
            if (listeners.length is 0) {
                queuedMessages.add(status);
                return;
            }
        }
        for (int i = 0; i < listeners.length; i++) {
            try {
                listeners[i].logging(status, IRuntimeConstants.PI_RUNTIME);
            } catch (Exception e) {
                handleException(e);
            } catch (LinkageError e) {
                handleException(e);
            }
        }
    }

    private static void handleException(Throwable e) {
        if (!( null !is cast(OperationCanceledException)e )) {
            // Got a error while logging. Don't try to log again, just put it into stderr 
            e.printStackTrace();
        }
    }

    /**
     * Helps determine if any listeners are registered with the logging mechanism.
     * @return true if no listeners are registered
     */
    public static bool isEmpty() {
        synchronized (logListeners) {
            return (logListeners.size() is 0);
        }
    }

}
