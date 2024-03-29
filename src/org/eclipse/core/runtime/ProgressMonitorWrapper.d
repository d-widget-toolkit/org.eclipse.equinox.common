/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module org.eclipse.core.runtimeProgressMonitorWrapper;

import java.lang.all;

import org.eclipse.core.runtimeIProgressMonitorWithBlocking; // packageimport
import org.eclipse.core.runtimeAssert; // packageimport
import org.eclipse.core.runtimeIProgressMonitor; // packageimport
import org.eclipse.core.runtimeIStatus; // packageimport

/**
 * An abstract wrapper around a progress monitor which,
 * unless overridden, forwards <code>IProgressMonitor</code>
 * and <code>IProgressMonitorWithBlocking</code> methods to the wrapped progress monitor.
 * <p>
 * This class can be used without OSGi running.
 * </p><p>
 * Clients may subclass.
 * </p>
 */
public abstract class ProgressMonitorWrapper : IProgressMonitor, IProgressMonitorWithBlocking {

    /** The wrapped progress monitor. */
    private IProgressMonitor progressMonitor;

    /** 
     * Creates a new wrapper around the given monitor.
     *
     * @param monitor the progress monitor to forward to
     */
    protected this(IProgressMonitor monitor) {
        Assert.isNotNull(monitor);
        progressMonitor = monitor;
    }

    /** 
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#beginTask(String, int)
     */
    public void beginTask(String name, int totalWork) {
        progressMonitor.beginTask(name, totalWork);
    }

    /**
     * This implementation of a <code>IProgressMonitorWithBlocking</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitorWithBlocking#clearBlocked()
     * @since 3.0
     */
    public void clearBlocked() {
        if ( null !is cast(IProgressMonitorWithBlocking)progressMonitor )
            (cast(IProgressMonitorWithBlocking) progressMonitor).clearBlocked();
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#done()
     */
    public void done() {
        progressMonitor.done();
    }

    /**
     * Returns the wrapped progress monitor.
     *
     * @return the wrapped progress monitor
     */
    public IProgressMonitor getWrappedProgressMonitor() {
        return progressMonitor;
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#internalWorked(double)
     */
    public void internalWorked(double work) {
        progressMonitor.internalWorked(work);
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#isCanceled()
     */
    public bool isCanceled() {
        return progressMonitor.isCanceled();
    }

    /**
     * This implementation of a <code>IProgressMonitorWithBlocking</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitorWithBlocking#setBlocked(IStatus)
     * @since 3.0
     */
    public void setBlocked(IStatus reason) {
        if ( null !is cast(IProgressMonitorWithBlocking)progressMonitor )
            (cast(IProgressMonitorWithBlocking) progressMonitor).setBlocked(reason);
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#setCanceled(boolean)
     */
    public void setCanceled(bool b) {
        progressMonitor.setCanceled(b);
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#setTaskName(String)
     */
    public void setTaskName(String name) {
        progressMonitor.setTaskName(name);
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#subTask(String)
     */
    public void subTask(String name) {
        progressMonitor.subTask(name);
    }

    /**
     * This implementation of a <code>IProgressMonitor</code>
     * method forwards to the wrapped progress monitor.
     * Clients may override this method to do additional
     * processing.
     *
     * @see IProgressMonitor#worked(int)
     */
    public void worked(int work) {
        progressMonitor.worked(work);
    }
}
