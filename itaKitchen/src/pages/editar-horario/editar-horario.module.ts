import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { EditarHorarioPage } from './editar-horario';

@NgModule({
  declarations: [
    EditarHorarioPage,
  ],
  imports: [
    IonicPageModule.forChild(EditarHorarioPage),
  ],
})
export class EditarHorarioPageModule {}
