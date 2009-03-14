/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module org.eclipse.core.runtime.MultiStatus;

import org.eclipse.core.runtime.Assert;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.IStatus;

import java.lang.all;
static import tango.text.Text;

/**
 * A concrete multi-status implementation,
 * suitable either for instantiating or subclassing.
 * <p>
 * This class can be used without OSGi running.
 * </p>
 */
public class MultiStatus : Status {

    /** List of child statuses.
     */
    private IStatus[] children;

    /**
     * Creates and returns a new multi-status object with the given children.
     *
     * @param pluginId the unique identifier of the relevant plug-in
     * @param code the plug-in-specific status code
     * @param newChildren the list of children status objects
     * @param message a human-readable message, localized to the
     *    current locale
     * @param exception a low-level exception, or <code>null</code> if not
     *    applicable
     */
    public this(String pluginId, int code, IStatus[] newChildren, String message, Exception exception) {
        this(pluginId, code, message, exception);
        Assert.isLegal(newChildren !is null);
        int maxSeverity = getSeverity();
        for (int i = 0; i < newChildren.length; i++) {
            Assert.isLegal(newChildren[i] !is null);
            int severity = newChildren[i].getSeverity();
            if (severity > maxSeverity)
                maxSeverity = severity;
        }
        this.children = new IStatus[newChildren.length];
        setSeverity(maxSeverity);
        SimpleType!(IStatus).arraycopy(newChildren, 0, this.children, 0, newChildren.length);
    }

    /**
     * Creates and returns a new multi-status object with no children.
     *
     * @param pluginId the unique identifier of the relevant plug-in
     * @param code the plug-in-specific status code
     * @param message a human-readable message, localized to the
     *    current locale
     * @param exception a low-level exception, or <code>null</code> if not
     *    applicable
     */
    public this(String pluginId, int code, String message, Exception exception) {
        super(OK, pluginId, code, message, exception);
        children = new IStatus[0];
    }

    /**
     * Adds the given status to this multi-status.
     *
     * @param status the new child status
     */
    public void add(IStatus status) {
        Assert.isLegal(status !is null);
        IStatus[] result = new IStatus[children.length + 1];
        SimpleType!(IStatus).arraycopy(children, 0, result, 0, children.length);
        result[result.length - 1] = status;
        children = result;
        int newSev = status.getSeverity();
        if (newSev > getSeverity()) {
            setSeverity(newSev);
        }
    }

    /**
     * Adds all of the children of the given status to this multi-status.
     * Does nothing if the given status has no children (which includes
     * the case where it is not a multi-status).
     *
     * @param status the status whose children are to be added to this one
     */
    public void addAll(IStatus status) {
        Assert.isLegal(status !is null);
        IStatus[] statuses = status.getChildren();
        for (int i = 0; i < statuses.length; i++) {
            add(statuses[i]);
        }
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public override IStatus[] getChildren() {
        return children;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public override bool isMultiStatus() {
        return true;
    }

    /**
     * Merges the given status into this multi-status.
     * Equivalent to <code>add(status)</code> if the
     * given status is not a multi-status.
     * Equivalent to <code>addAll(status)</code> if the
     * given status is a multi-status.
     *
     * @param status the status to merge into this one
     * @see #add(IStatus)
     * @see #addAll(IStatus)
     */
    public void merge(IStatus status) {
        Assert.isLegal(status !is null);
        if (!status.isMultiStatus()) {
            add(status);
        } else {
            addAll(status);
        }
    }

    /**
     * Returns a string representation of the status, suitable
     * for debugging purposes only.
     */
    public override String toString() {
        tango.text.Text.Text!(char) buf = new tango.text.Text.Text!(char);
        buf.append(super.toString());
        buf.append(" children=["); //$NON-NLS-1$
        for (int i = 0; i < children.length; i++) {
            if (i !is 0) {
                buf.append(" "); //$NON-NLS-1$
            }
            buf.append( (cast(Object)children[i]).toString());
        }
        buf.append("]"); //$NON-NLS-1$
        return buf.toString();
    }
}
