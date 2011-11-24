#!/usr/bin/env python
#-*- coding: utf-8 -*-
#Copyright (C) 2011 ISVTEC SARL
#$Id$
__author__ = "Ousmane Wilane ♟ <ousmane@wilane.org>"
__date__   = "Fri Nov 11 11:01:48 2011"

from django.conf.urls.defaults import patterns, url

urlpatterns = patterns('',
                       url(r'^companies$', 'invoice.views.list_companies', name='list_companies'),
                       url(r'^list/(?P<customer_id>\d+)$', 'invoice.views.list_invoices', name='list_invoices'),
                       url(r'^show/(?P<invoice_id>\d+)$', 'invoice.views.detail_invoice', name='detail_invoice'),
                       url(r'^accept/(?P<invoice_id>\d+)$', 'invoice.views.accept_quote', name='accept_quote'),
                       url(r'^download/(?P<invoice_id>\d+)$', 'invoice.views.download_invoice', name='download_invoice'),
                       
                       url(r'^hipay/(?P<invoice_id>\d+)$', 'invoice.views.hipay_invoice', name='hipay_invoice'),
                       
                       url(r'^hipay/payment/(?P<action>cancel|ok|nook)/(?P<invoice_id>\d+)$', 'invoice.views.hipay_payment_url', name='hipay_payment_url'),
                       url(r'^hipay/result/ack/(?P<invoice_id>\d+)$', 'invoice.views.hipay_ipn_ack', name='hipay_ipn_ack'),
                       url(r'^hipay/shop/logo$', 'invoice.views.hipay_shop_logo', name='hipay_shop_logo'),
)
