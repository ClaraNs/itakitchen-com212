import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { EsquecerSenhaPage } from './esquecer-senha';

@NgModule({
  declarations: [
    EsquecerSenhaPage,
  ],
  imports: [
    IonicPageModule.forChild(EsquecerSenhaPage),
  ],
})
export class EsquecerSenhaPageModule {}
