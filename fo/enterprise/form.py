#!/usr/bin/env python
#-*- coding: utf-8 -*-
#Copyright (C) 2011 ISVTEC SARL
#$Id$
__author__ = "Ousmane Wilane ♟ <ousmane@wilane.org>"
__date__   = "Fri Nov 11 16:20:46 2011"


from django import forms
from enterprise.models import Clients, Invitation
from django.utils.translation import ugettext_lazy as _

class EnterpriseForm(forms.ModelForm):
    class Meta:
        model = Clients
        exclude = ['users', 'id_user', 'total_du_ht', 'has_devis', 'has_unpaid',
                   'id_client', 'password', 'id_company_type', 'ca_total_ht_year',
                   'ca_total_ht']


class InvitationForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        qs = kwargs.pop('qs')
        super(InvitationForm, self).__init__(*args, **kwargs)
        self.fields['company'] = forms.ModelChoiceField(queryset=qs, empty_label=_("Choose a company"))

    class Meta:
        model = Invitation
        exclude = ['token']
        
